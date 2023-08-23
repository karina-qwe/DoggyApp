# 🐶 DoggyApp 🐶
Hi! It's my diploma project.

Doggy is an iOS mobile app for classifying dog breeds using live camera or image. 
The main screen displays device’s camera. Also the main screen has a label, which shows result of classifying object, and the 'gallery' icon, 
which allows to open device’s gallery and select an image to classify.

## How it works?
In general, the recognition process starts from the main screen. 
It is enough for the user just to point the phone at the desired object to determine the breed of a dog. 
The application logic is implemented in such a way as to throttle input images stream in order to avoid each frame processing and recognition.
This approach reduces the load on computing resources and energy consumption. 

There are two ways to get more info about the recognized dog breed:
- _tap the label_. This's enough to load a screen with the detailed information;
- _tap the 'gallery' icon_. If you tap the 'gallery' icon and select an image, the dog breed is identified and the detailed information screen is also loaded.

If there is no Internet connection, Doggy is able to perform the function of recognizing the dog breed, 
but the detailed information screen will show an error message about obtaining a detailed description of the breed.


## Where to find detailed breed info?
So, the top part of the mobile screen is occupied by the given input image with the name of the defined breed and the probability in percentage format. 
The rest of the screen shows the information received from the server. 

Such parameters like lifespan, weight, height are average values for males and females, and are indicated in years, kg and cm respectively. 
In addition, lower on the screen could be found the rating information for main breed characteristics, where 1 is the lowest and 5 is the highest grade. 

## Demo Time!


https://github.com/karkhotin/DoggyApp/assets/54355397/2e791325-4dc6-4ec9-9565-56dfe15261fd



For example, according to the information presented in the video, the Border Collie requires moderate grooming (3 out of 5),
also breed representatives are really noisy 'cause barking equals to 4 out of 5, and the level of playfulness corresponds to 5,
which means that representatives of the breed don't stop loving to play even in adulthood.

## Thanks for your attention 💕
