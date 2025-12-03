import time
from cloudflare import Cloudflare

client = Cloudflare(
    api_email="harry@email.com", #Use your Cloudflare Email
    api_key="101010101010101" #Replace with your Global API Key - do not save this API anywhere, delete after!
)

def process_all_invites_manually():
    page_num = 1
    total_processed = 0
    
    print("Starting")
    
    while True:
        print(f"Fetching Page {page_num}...")
        
        try:
            #Fetch from CF
            current_page = client.user.invites.list(
                extra_query={
                    "page": page_num,
                    "per_page": 50  #Max allowed per request
                }
            )
            
            #Checking through the results
            invites_on_page = getattr(current_page, 'result', current_page)
            
            #If the list is empty, we are done
            if not invites_on_page:
                print("No more invites found. Scan complete.")
                break
            
            #Process Section
            for invite in invites_on_page:
                total_processed += 1
                
                #Safe attribute access
                org_name = getattr(invite, 'organization_name', 'Unknown Org')
                invited_email = getattr(invite, 'invited_member_email', 'Unknown Email')
                
                print(f"[{total_processed}] Invite ID: {invite.id}")
                print(f" - Org: {org_name}")
                print(f" - Status: {invite.status}")

                if invite.status == 'pending':
                    print(f" ->  PENDING: Accepting...")
                    try:
                        client.user.invites.edit(invite_id=invite.id, status="accepted")
                        print(f" -> Accepted!")
                        time.sleep(0.2) 
                    except Exception as e:
                        print(f" ->  Failed: {e}")
                
                elif invite.status == 'accepted':
                    print(" ->  Skipping (Already accepted)")
                
                print("---")
            
            #Going to next page, otherwise Call Limit will be reached
            page_num += 1
            #Wait to avoid hitting API rate limits (1200 req/5 min)
            time.sleep(0.5)
            
        except Exception as e:
            print(f"Critical Error on Page {page_num}: {e}")
            break

    print(f"Final Total Processed: {total_processed}")

if __name__ == "__main__":
    process_all_invites_manually()
