# verbose-octo-robot

An iOS mobile app to post images, and view thier mapped locations.


# details

account: 
- user authorization is handled by FirebaseAuth and a custom 'contributor' type is saved as a document in Firestore Cloud Database.  
- contributor profile image is saved to FireStore storage bucket, and the url is saved to the user document on upload.
- during account creation, a home address is required which is automicatically converted using reverse geocoding to a coordinate location.

![create-account](https://github.com/Pierre81385/verbose-octo-robot-swfitui/blob/main/readme_assets/create_account.png?raw=true) ![login](https://github.com/Pierre81385/verbose-octo-robot-swfitui/blob/main/readme_assets/login.png?raw=true)

![profile](https://github.com/Pierre81385/verbose-octo-robot-swfitui/blob/main/readme_assets/view_profile.png?raw=true)

submit:
- an image can be attached
- submissions take a name and description text
- submissions are categorized as lost, found, or spotted which determines the map annotation icon.
- submissions use either your current location or home address (witnessed an accident versus lost my dog, for example)

map:
- view annotations near your current location or around your designated home address
- tap an annotation to view details (in progress)
- filter by category or age (in progress)

list: 
- view submissions in a list format
- filter by creator (in progress)
- sort by age, popularity, or distance (in progress)


