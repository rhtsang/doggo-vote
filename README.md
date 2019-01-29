# doggo-vote
Yelp for Dogs. Rate your favorite doggos and see them show up on the top doggos board! Or upload pictures of your dogs for others to rate :)

## Trello Board: https://trello.com/b/qfw0AYvf/doggovote

## Team members & Description of what each team member did:

### Sam (samclee)

Resident Firebase Storage expert (the service that hosts our dog pictures). Designed the Firebase data structures that store information about the dogs and users. Built the Top Doggos screen and organized the necessary infrastructure in Firebase needed to support a global dog leaderboard. Generally just cleaned up everyone's UI constraints since they looked awful on anything other than an iPhone XR. I'm especially proud of commit 44837239fb59ba4948485f87a7ce4920cbe6e823. I worked for a solid amount of time learning how to synchronize Firebase Storage calls and I'm glad it works.

### Jess (jessnguyen)
Worked on the dog rating screen (DoggoViewController): update score in database after user rates a dog, write code to pick a random dog from a random user to display onto the view controller. Set up login screen (LoginViewController) and added the option to logout.
Submitted sprint planning notes/milestone and set up meetings. 
Worked with other team members to set up/refactor the database and improve the UI of the app.

### Raymond (rhstang)
Setup Firebase to be integrated into the app  
Wrote MyDoggosViewController and AddDoggoViewController to allow the user to see and add his/her own dogs to the database  
Create custom table view cell to show all the relevant information to a dog in the table views of MyDoggosViewController and TopDoggosViewController  
Set up user authentification (login/sign up) in LoginViewController

### Nihal (niman565)
Worked on getting top doggos from database and keeping track of the top dogs. Also worked on changing top doggos as needed and pushing back to database. Finally, assisted other team members as needed with other tasks.

