# Lion Pool

**This is LionPool**, an app that allows you to match with other Columbia students who are going to the same airport at the same time, therefore, allowing coordination between both parties to travel to the airport together. However, with expanded use, this idea can be used for traveling all over the city. 

## Beginning Stages

I started this project Summer '22. But, I was far too early in my studies to be able to actually execute such a task. I vaguely was able to develop some of the SwiftUI Views based on some tutorials, but school started and I put Lion Pool away. Then Summer '23, I came back having another year of coding knowledge and things moved quite quickly. Initially, I started with prototyping on Figma and asking friends and family for critiques. Link [here](https://www.figma.com/file/GYfocAxIqSB0fCn95KV0N3/Lion-Pool?type=design&node-id=9%3A3&mode=design&t=qbPSQjdSvD2N0c2R-1) (I LOVE FIGMA SM). 

Starting Summer '23, the project started moving very quickly. I had no idea how much work this app would be, there were things that I needed to do that I had no idea even existed. Here are some details

## Architecture Details

Lion Pool is a three-tier architecture application. **App -> Backend Server -> Data Source**. By mid-June, the app was able to create users, store their data, and log upcoming flights. The app operated as a two-tier architecture application, with the app directly interacting with the data source. However, I spent a couple of days fixing this and then ideating and designing the backend server and noticed remarkable improvements on performance. 

The application is coded entirely in **Swift and SwiftUI using a MVVM design pattern (Model-View-View Model)**. This separates a lot of logic and presentation logic from the UI, resulting in a much smoother front end. The application interacts with the backend server via HTTP POST/GET Requests.

The backend server is coded in NodeJS using the ExpressJS framework, which I self-learned for this project. It is quite simple, **the backend is hosted on a Google Cloud Platform Compute Engine (a VM)**, a platform that I never worked with before. The backend just processes and serves HTTP requests from the frontend application, most of the time having to request or write data to and from the data source. **The data is stored in Google's Firebase and Firestore.** It was really interesting to design the database in a way to reduces the amount of read and write per user during an average user session. 

**My first implementation was quite bad, but with some restructuring and database indexes, and with some caching that I implemented in the backend, I was able to significantly reduce the number of reads from the database.**

Over time, seeing success with working with different platforms and enabling new features, **my confidence really grew in my ability to learn and implement features**x despite not knowing anything about it prior. For example, I wanted to integrate Instagram API to allow Lion Pool users to connect their Instagram. This was my proudest moment (getting this to work):


This feature singlehandedly took me hours and hours and 100s of rabbit-holes from never-ending embedded Apple Developer support links to figure out. 

1. Instagram requires a callback URI (basically a destination for their user data upon linking accounts) to be an actual domain and not just an IP address. Throughout the app, my app was sending HTTP requests to my GCP VM's IP address and the port that the server was listening on. So I had to buy, (lion-pool.com)[lion-pool.com]. 

https://github.com/philluple/Lion-Pool/assets/101436499/7010947b-a575-4e6c-8f5a-12891f67272b

2. After learning about DNS records, I submitted a couple of my own A records (because I kept messing up) to associate my new domain with my server. 

3. Then, I realized that the callback URI had to be HTTPS, not HTTP. I then got a free SSL/TLS certificate from GoCert

4. I then had to set up a Universal Link to associate the domain with my app and allow redirects from the browser back to Lion Pool

5. I had to set up a reverse proxy and configure the domain/server with Nginx (never heard of or used before) to forward requests to lion-pool.com (from the frontend) to my server. 

I learned the most about implementing this feature, and am really proud of myself for accomplishing this. However, it doesn't seem to be over because of Apple's new network security updates for iOS 17. 


## Conclusion

I am anticipating the launch of Lion Pool by the end of October as I am preparing for submission to Apple for review and Beta testing with a small group of friends. In all, Lion Pool is a project I am very proud of and represents a culmination of my studies at Columbia as well as countless hours of my own research. I probably worked 200+ hours on this total with more to come. 


















