This project is built with the help of AI tools,
mainly BARD and GitHub Copilot.
The purpose of the project is to test and apply the skills learnt in AI assisted programming and API integration
The project funtionality is as follows:

1. The user is presented with a textbox to enter the City of interest and click on a button to update the data
2. Once the update button clicked, coordinates corresponding to the location are determined using the CoreLocation package
3. From the coordinates, a call is sent to the openweathermap api to fetch weather data for the location of interest in an asynchronous URLSession.
4. The fetched data is decoded, and the maximum daily temperature and minimum daily temperature are determined, and displayed
 
5. A simple map with a pin is also shown/updated to show the location of the city/location entered by the user using the MapKit package.
 
// Documentation on api call: https://docs.openweather.co.uk/current#data

 Note: - The openweathermap api uses HTTP connection. Thus, it was necessary to disable App Transport Security (ATS)restrictions for the app (https://developers.google.com/admob/ios/privacy/app-transport-security)
        - an api key was required to be able to use openweathermap API
