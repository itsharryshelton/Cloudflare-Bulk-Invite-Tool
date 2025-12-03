# --- CONFIGURATION ---
$CF_EMAIL = "harry@email.co.uk"      # Replace with your Cloudflare Email
$CF_KEY   = "111111111111"      # Replace with your Global API Key
# ---------------------

$BaseUrl = "https://api.cloudflare.com/client/v4"
$headers = @{
    "X-Auth-Email" = $CF_EMAIL
    "X-Auth-Key"   = $CF_KEY
    "Content-Type" = "application/json"
}

function Start-InviteScan {
    $pageNum = 1
    $totalProcessed = 0
    
    Write-Host "--- Starting Cloudflare Invite Scan ---" -ForegroundColor Cyan
    
    while ($true) {
        Write-Host "📥 Fetching Page $pageNum..." -ForegroundColor Cyan
        
        #Used pagination parameters other will fail
        $listUrl = "$BaseUrl/user/invites?page=$pageNum&per_page=50"
        
        try {
            $response = Invoke-RestMethod -Uri $listUrl -Method Get -Headers $headers -ErrorAction Stop
            $invites = $response.result
            if (-not $invites -or $invites.Count -eq 0) {
                Write-Host "✅ No more invites found. Scan complete." -ForegroundColor Green
                break
            }
            
            #Process each one
            foreach ($invite in $invites) {
                $totalProcessed++
                
                $orgName = if ($invite.organization_name) { $invite.organization_name } else { "Unknown Org" }
                $invitedEmail = if ($invite.invited_member_email) { $invite.invited_member_email } else { "Unknown Email" }
                $status = $invite.status
                $inviteId = $invite.id
                
                Write-Host "[$totalProcessed] Invite ID: $inviteId"
                Write-Host " - Org:    $orgName"
                Write-Host " - Email:  $invitedEmail"
                Write-Host " - Status: $status"

                #ACCEPT PENDING
                if ($status -eq 'pending') {
                    Write-Host " -> PENDING: Accepting..." -NoNewline -ForegroundColor Yellow
                    
                    $editUrl = "$BaseUrl/user/invites/$inviteId"
                    $jsonBody = @{ status = "accepted" } | ConvertTo-Json
                    
                    try {
                        $acceptResponse = Invoke-RestMethod -Uri $editUrl -Method Patch -Headers $headers -Body $jsonBody -ErrorAction Stop
                        
                        if ($acceptResponse.success) {
                            Write-Host " SUCCESS!" -ForegroundColor Green
                        } else {
                            Write-Host " FAILED (API returned success=false)" -ForegroundColor Red
                        }
                        
                        # Small sleep to be kind to the API
                        Start-Sleep -Milliseconds 200
                    }
                    catch {
                        Write-Host " ERROR: $($_.Exception.Message)" -ForegroundColor Red
                    }
                }
                elseif ($status -eq 'accepted') {
                    Write-Host " ->  Skipping (Already accepted)" -ForegroundColor Gray
                }
                
                Write-Host "---"
            }
            
            #NEXT PAGE
            $pageNum++
            #Sleep slightly to avoid hitting rate limits (1200 req/5 min)
            Start-Sleep -Milliseconds 500
            
        }
        catch {
            Write-Host "Critical Error on Page $pageNum : $($_.Exception.Message)" -ForegroundColor Red
            # Print more detail if it's a web response error
            if ($_.Exception.Response) {
                $stream = $_.Exception.Response.GetResponseStream()
                $reader = New-Object System.IO.StreamReader($stream)
                Write-Host "API Response: $($reader.ReadToEnd())" -ForegroundColor Red
            }
            break
        }
    }
    
    Write-Host "Final Total Processed: $totalProcessed" -ForegroundColor Cyan
}

# Run the function
Start-InviteScan
