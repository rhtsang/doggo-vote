# DoggoVote
An app that allows users to upload their dogs to a database and let other users rate them. The app presents random dogs for the user to view and rate, but also has a list of the top dogs from around the world.  

## Trello
https://trello.com/b/qfw0AYvf/doggovote  

## Notes
### Meeting 1: 11/DD/18
#### (1) What We Did  
Nothing, since this was our first meeting!
#### (2) What We Plan To Do
Jess: Write up all the stuff we need to turn in, and learn Firebase <br/>
Sam: Learn Firebase <br/>
Nihal: Learn how to access camera and photo library to select pictures to upload to Firebase <br/>
Raymond: Create base project and view controllers, and learn Firebase <br/>
#### (3) Issues
None, since this was our first meeting!  

### Meeting 2: 11/25/18
#### (1) What We Did
We created all the view controllers we wanted for our app (https://github.com/ECS189E/doggo-vote/commit/82678b11730ed7101d12af36fd6c74c93f79c604) <br/>
We figured out how to upload pictures to Firebase and how to pull data from Firebase. On our Doggo View Controller (where the dogs get rated), we successfully display the pictures from our Firebase database. (https://github.com/ECS189E/doggo-vote/commit/970fb2dd1aa2845ec8812fa0d473f216d5522294) <br/>
We also wrote the code to attain the number of pictures currently in the database with our current data model and improved our UI for the Doggo View Controller (https://github.com/ECS189E/doggo-vote/commit/8ead938fc54d16ad5a4bb1c44452f8d8c02a4428) <br/>

#### (2) What We Plan To Do
All members: <br/>
Figure out our database model (how we want to store the information associated with each dog - name, owner, rating). <br/>
Pull the top 3 dogs for our Top Voted Dogs view controller. <br/>

#### (3) Issues
None.

### Meeting 3: 12/2/18
#### (1) What We Did
We refactored our data model (on Firebase), so this led to some changes in the way we pull our photos/dog name to display on the app (https://github.com/ECS189E/doggo-vote/commit/4b2e6cd37fdd0ed52c15c8a67c80cff5793d831b) <br/>
We are now able to pull the pictures of the top doggos in the Top Doggos Tab (https://github.com/ECS189E/doggo-vote/commit/94598d071d5be86bf2d0778eaa00b631645e22a0) & pictures the user have uploaded (https://github.com/ECS189E/doggo-vote/commit/f23a6040f8f200d3198aecc015721017985888c8) <br/>
We added the code to update the doggo's score in the database after a user rates it (https://github.com/ECS189E/doggo-vote/commit/706ff2a06b897403ac31303ada0cd69bd822d37f) <br/>
We added a login screen (https://github.com/ECS189E/doggo-vote/commit/52f0b4644f5228c24d88ec7b53b9026942ba6079) with the option for user account sign up (https://github.com/ECS189E/doggo-vote/commit/08f75caae92e649d85fd23d7d306d49751beeeec) <br/>

#### (2) What We Plan To Do
All members: <br/>
We still have to update the rating of a dog after the user rates it and improve our app design/UI stuff. 

#### (3) Issues 
Dealing with async calls and figuring out synchronization primitives for our app.

## Commits
### Base project with view controllers: https://github.com/ECS189E/doggo-vote/commit/6f63e21b9e613748bea9662a002aa25c46d9c8ee
### Firebase integration: https://github.com/ECS189E/doggo-vote/commit/842f59d4d71f1b5aea11a532b5e54c396aa10410
### More view controllers: https://github.com/ECS189E/doggo-vote/commit/82678b11730ed7101d12af36fd6c74c93f79c604  

## Other
