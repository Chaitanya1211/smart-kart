# Smart Kart

## Introduction

This system was created using the Flutter framework, which uses the Dart programming language, and Firebase as the database. Google's Flutter is an open-source user interface software development kit. It is used to create cross-platform applications from a single codebase for Android, iOS, Linux, macOS, Windows, Google Fuchsia, and the web. Google's Firebase technology allows developers to create mobile and online applications. It started off as a stand-alone business in 2011. Google bought the platform in 2014, and it is now their main option for app creation. It is a NoSql database which works in document format

The project's main database is Firebase Firestore, a NoSQL database that uses collections and documents. Only Firebase's login and registration functionality is used.

## Technologies Used

- Flutter
- Dart
- Firebase

## Project screenshots
## User Homepage
![User Homepage](./projectImages//UserHome.jpg?raw=true "Title")

Here the user will be able to see all the previous shopping he/she had done. It will contain the deyails of items brought, the cart total and Payment ID.

## User starts new shopping 
- **User New Shopping Page**
- 
<p align="center">
  <img src="./projectImages/UserHome.jpg?raw=true" alt="User Homepage" title="User Homepage">
</p>

After clicking on Start new shopping button on the User Homepage the user will be prompted to add a title to the nre shopping and this screeen will appear.

- **Items added after scanning**
![User New Shopping](./projectImages//UserShoppingSession.jpg?raw=true "Title")

As the user clicks on add item he/she will be prompted to scan the QR Code on the item and after successfull scan the item will be visible in the list. The cart subtotal gets calculated dynamically.

- **Items summary screen**
![User New Shopping](./projectImages//UserShoppingSummary.jpg?raw=true "Title")

This screen shows the cart summary and give an option to pay via Razorpay

-- **Payment Success**

![User New Shopping](./projectImages//UserPaymentSuccess.jpg?raw=true "Title")
After the payment is successfull the user will be shown the Payment ID and will be redircted to the Homepage




