# STAT 360 Group Project 
### Ryan Nelson, Peter Roessler-Caram, Michael Schatzel, Jimmy Kroll, and Trevor Tracy
### STAT 360 | Professor Amelia McNamara
### 21 May 2019

 https://nels6906.shinyapps.io/minnie_map_app/


# Documentation

## Project Outline

Our final project deliverable is an R Shiny app that allows the user to view an interactive map of the Twin Cities light rail public transportation grid. The application uses clustering parameters that generate the most efficient (defined in methodology) public transportation lines based on a chosen “train stop” word or phrase. The train stops will be non-traditional stop locations that ideally consist of franchises of fast food restaurants, coffee shops, other stores, or general locations like "Golf Courses" or "Parks" that serve as a set of locations under the general description. The "train stop" functionality of the Shiny App will resemble the Google Maps service, so users can search for the map locations by simply typing the location or set of locations' name in the app.  This map is not intended to be the future direction of the Metro Transit organization, but rather will put into perspective the spread and reach of these "train stop" map locations. 

## Data Collection

Data collection will be self-contained with the app via a Google Maps API based on the user's search criteria using the "googleway" R package. Each time a new location is searched in the app, new location data is collected. In order for the app to work optimally, we suggest that the user search for franchises or location names with a large number of locations (ideally 30 or more) in the Twin Cities area. When we collect data from Google Maps, we collect up to 60 locations (3 pages of 20 locations). This number of location data points gives the user the ability to graph more than a few transit lines that provide efficient routes across the Twin Cities Metro.

In collecting the first 60 data locations, we use a starting reference location corresponding to the Hennepin County Government Center in Downtown Minneapolis and limit the search to a 10 mile radius from this point. We chose this as the reference origin for collecting data as it is near the center of the Twin Cities Metro area and is close to the current hub for the Metro Transit Light Rail. Besides the origin location criteria, it is not crystal clear to us what additional criteria is used by the Google Maps application to determine the order the output locations appear. We speculate there is a component of popularity (Google Reviews perhaps), potentially an additional matching algorithm based on the data Google already has on the individual, or even a paid promotional angle. If the latter two are prevalent, we disclose that we use Trevor's gmail account for the Google Maps output data. 

## Methodology

Our methodology for creating the R Shiny App consists of mainly five packages: Tidyverse to perform data collection and manipulation, leaflet to visualize maps and graph transit routes of the Twin Cities Metro area, googleway to collect the location data, geosphere to determine distances for our starting point to select location points, and Shiny to develop our application.

To determine the transit routes, K-means clustering is used to select locations for the route to follow. K-means is a clustering technique that creates clusters based on minimizing the variation (sum of squared errors) within each cluster. This serves to create the most homogeneous clusters (locations being the most similar in terms of latitude and longitude, i.e. the closest to each other). Each cluster of data locations is used to create a light rail train transit route. The number of transit routes (and thus the number of clusters) is determined by the app user (between 3 and 8).

## Mapping

As mentioned in the methodology, the set of locations that are considered in mapping each light rail route are clustered using K-Means clustering. When a cluster of locations is determined, the center of the cluster becomes the end point for that individual route. Once all of the cluster center's are determined, the starting point for all of the routes is determined by creating a cluster of all of the cluster center's and finding this cluster's center. This starting point for all routes can be thought of as the transit system's center hub. It should be noted that neither the starting point nor a route's endpoint is necessarily a location determined by the user. The start/end points are simply the center of a cluster of these searched locations.

Each route between the starting central hub and the end point follows the fastest vehicle path. The route is created using the google_directions function of the googleway package. The route that is created matches the same route that would be created if you used the same start and end point in the Google Maps application and selected the car directions option. It is our understanding that the traffic conditions that are factored into the "fastest route" calculated are real-time traffic conditions based on when the user clicks "Build Routes".

## App Instructions

The "Minnie Map" Shiny app is simple and very user friendly. When a user first launches the app, a transportation grid of the Twin Cities Metro area appears, provided by the leaflet R package. The following steps allow the user to operate the Minnie Map:
### 1. Enter a search location or location phrase and click Search
    This step populates the app with the location data and shows up to 60 of the searched data points on the map.
    Once the search button is pressed, a loading bar appears for 10-12 seconds as the Google Maps API is used.
### 2. Use the slider to set how many transit routes to build and click Build Routes
    This step uses the K-means clustering algorithm to determine the routes and colors each route a different color.
    Roads where multiple routes overlap, or where a roadway is shared by multiple routes, is shown as a different color
    until the individual routes split away. This is commmon near the starting central hub.
### 3. The user can also toggle to show the current Metro Transit routes on the map for comparitive purposes. 
    These routes are shown as black, dashed lines.
### 4. To reset the map, users can click Recenter Map and Clear Map to view a clean map
    Users can zoom in/out of the map display and drag the map to view other areas besides the Twin Cities.

Additionally, error messages appear when these steps are not followed appropriately. The user can also see how many locations appear on the map in the bottom right of the app to ensure they are seeing the number of locations they expected before building routes.

## Concluding Thoughts

The Minnie Map app performs with great efficiency and accuracy. We are very happy with the versatility of the app as well. We first envisioned the app only being used for a predetermined set of franschise locations that we would need to manually collect and cleanse before providing to the app. The accessibility of the googleway package and visual appeal of the leaflet package also gave our app a clean and legitimate appearance and increased its usability across all location and location phrase types.

While we do not envision this app being of practical use for Metro Transit's future decision making, the app does provide individuals people with worthwhile insights. A few applications we have explored include designing pub crawls by creating optimal routes from a central location to pocket of bars across town. Similarly, out-of-town guests to the Twin Cities could use the app to see what areas of the Twin Cities are heavily populated with parks or entertainment while providing an efficient route to get to that area. Finally, franchise management could use the app to see the spread of its locations and the travel preferences to these locations based on different starting locations, such as US Bank Stadium or the Guthrie Theatre. 

