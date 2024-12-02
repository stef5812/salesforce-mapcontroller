//copyright © 2024 Stefan Dodds @ stefandodds.ie, All rights reserved

var alzMarkers = [];
var primaryMarkers = [];
var chimeMarkers = [];
var councilMarkers = [];
var hospitalsMarkers = [];
var gardaMarkers = [];
var pharMarkers = [];
var healthMarkers = [];
var mowMarkers = [];
var mabsMarkers = [];
var ncbiMarkers = [];
var wheelMarkers = [];
var nursingMarkers = [];

var alzMarkersVisible = false;
var primaryMarkersVisible = false;
var chimeMarkersVisible = false;
var councilMarkersVisible = false;
var hospitalsMarkersVisible = false;
var gardaMarkersVisible = false;
var pharMarkersVisible = false;
var healthMarkersVisible = false;
var mowMarkersVisible = false;
var mabsMarkersVisible = false;
var ncbiMarkersVisible = false;
var wheelMarkersVisible = false;
var nursingMarkersVisible = false;

var currentlyOpenInfoWindow = null; // Consolidated variable to track the open InfoWindow

function addGardaMarker(location, iconUrl, markerType) {
    if (!location.LatLng__Latitude__s || !location.LatLng__Longitude__s) {
        console.warn("Invalid location data (missing latitude/longitude): ", location);
        return null;
    }

    var latLng = new google.maps.LatLng(location.LatLng__Latitude__s, location.LatLng__Longitude__s);

    var iconUrl = location.Other__c === '24-Jul' ? 
        'https://stefandodds.ie/serv-dir/libs/icons/Garda247.png' : 
        'https://stefandodds.ie/serv-dir/libs/icons/Garda.png';

    var marker = new google.maps.Marker({
        position: latLng,
        map: map,
        title: location.Title__c || location.Name,
        icon: { url: iconUrl, scaledSize: new google.maps.Size(30, 40) }
    });

    var clickInfoWindow = new google.maps.InfoWindow({
        content: generateInfoWindowContent(location, markerType)
    });

    marker.addListener('click', function () {
        if (currentlyOpenInfoWindow) {
            currentlyOpenInfoWindow.close();
        }
        clickInfoWindow.open(map, marker);
        currentlyOpenInfoWindow = clickInfoWindow;
    });

    return marker;
}

function addCouncilMarker(location, iconUrl, markerType) {
    if (!location.LatLng__Latitude__s || !location.LatLng__Longitude__s) {
        console.warn("Invalid location data (missing latitude/longitude): ", location);
        return null;
    }

    var latLng = new google.maps.LatLng(location.LatLng__Latitude__s, location.LatLng__Longitude__s);

    var iconUrl;
    switch (location.Other__c) {
        case 'coco': iconUrl = 'https://stefandodds.ie/serv-dir/libs/icons/AUTH-icon.png'; break;
        case 'cyco': iconUrl = 'https://stefandodds.ie/serv-dir/libs/icons/AUTHcity-icon.png'; break;
        case 'regco': iconUrl = 'https://stefandodds.ie/serv-dir/libs/icons/AUTHreg-icon.png'; break;
        default: iconUrl = 'https://stefandodds.ie/serv-dir/libs/icons/bee.gif';
    }

    var marker = new google.maps.Marker({
        position: latLng,
        map: map,
        title: location.Title__c || location.Name,
        icon: { url: iconUrl, scaledSize: new google.maps.Size(30, 40) }
    });

    var clickInfoWindow = new google.maps.InfoWindow({
        content: generateInfoWindowContent(location, markerType)
    });

    marker.addListener('click', function () {
        if (currentlyOpenInfoWindow) {
            currentlyOpenInfoWindow.close();
        }
        clickInfoWindow.open(map, marker);
        currentlyOpenInfoWindow = clickInfoWindow;
    });

    return marker;
}

function addMedMarker(location, iconUrl, markerType) {
    if (!location.LatLng__Latitude__s || !location.LatLng__Longitude__s) {
        console.warn("Invalid location data (missing latitude/longitude): ", location);
        return null;
    }

    var latLng = new google.maps.LatLng(location.LatLng__Latitude__s, location.LatLng__Longitude__s);

    // Define the icon object conditionally based on the iconUrl
    var icon;
    if (iconUrl === "https://stefandodds.ie/serv-dir/libs/icons/hospital.png") {
        icon = { url: iconUrl, scaledSize: new google.maps.Size(30, 40) };
    } else {
        icon = { url: iconUrl, scaledSize: new google.maps.Size(30, 40) };
    }    

    var marker = new google.maps.Marker({
        position: latLng,
        map: map,
        title: location.Title__c || location.Name__c,      
        icon: icon
    });

    var clickInfoWindow = new google.maps.InfoWindow({
        content: generateInfoWindowContent(location, markerType)
    });

    marker.addListener('click', function () {
        if (currentlyOpenInfoWindow) {
            currentlyOpenInfoWindow.close();
        }
        clickInfoWindow.open(map, marker);
        currentlyOpenInfoWindow = clickInfoWindow;
    });

    return marker;
}

function toggleMedMarkers(type) {
    console.log("Toggling med markers for: " + type);

    var markerList, markersVisibleFlag;

    // Set the relevant marker list and visibility flag based on the type    
    if (type === 'alz') {
        markerList = alzMarkers;
        markersVisibleFlag = alzMarkersVisible;
    } else if (type === 'primary') {
        markerList = primaryMarkers;
        markersVisibleFlag = primaryMarkersVisible;
    } else if (type === 'chime') {
        markerList = chimeMarkers;
        markersVisibleFlag = chimeMarkersVisible;
    } else if (type === 'council') {
        markerList = councilMarkers;
        markersVisibleFlag = councilMarkersVisible;
    } else if (type === 'hospitals') {
        markerList = hospitalsMarkers;
        markersVisibleFlag = hospitalsMarkersVisible;
    } else if (type === 'garda') {
        markerList = gardaMarkers;
        markersVisibleFlag = gardaMarkersVisible;
    } else if (type === 'phar') {
        markerList = pharMarkers;
        markersVisibleFlag = pharMarkersVisible;
    } else if (type === 'gps') {
        markerList = gpsMarkers;
        markersVisibleFlag = gpsMarkersVisible;
    } else if (type === 'health') {
        markerList = healthMarkers;
        markersVisibleFlag = healthMarkersVisible;
    } else if (type === 'mow') {
        markerList = mowMarkers;
        markersVisibleFlag = mowMarkersVisible;
    } else if (type === 'dentist') {
        markerList = dentistMarkers;
        markersVisibleFlag = dentistMarkersVisible;
    } else if (type === 'mabs') {
        markerList = mabsMarkers;
        markersVisibleFlag = mabsMarkersVisible;
    } else if (type === 'ncbi') {
        markerList = ncbiMarkers;
        markersVisibleFlag = ncbiMarkersVisible;
    } else if (type === 'wheel') {
        markerList = wheelMarkers;
        markersVisibleFlag = wheelMarkersVisible;
    } else if (type === 'nursing') {
        markerList = nursingMarkers;
        markersVisibleFlag = nursingMarkersVisible;
    }

    // Toggle visibility
    markersVisibleFlag = !markersVisibleFlag;
    console.log("Setting med markers visibility to: " + markersVisibleFlag);

    markerList.forEach(function (marker) {
        marker.setVisible(markersVisibleFlag);
    });

    // Update the correct visibility flag after toggling
    if (type === 'alz') {
        alzMarkersVisible = markersVisibleFlag;
    } else if (type === 'primary') {
        primaryMarkersVisible = markersVisibleFlag;
    } else if (type === 'chime') {
        chimeMarkersVisible = markersVisibleFlag;
    } else if (type === 'council') {
        councilMarkersVisible = markersVisibleFlag;
    } else if (type === 'hospitals') {
        hospitalsMarkersVisible = markersVisibleFlag;
    } else if (type === 'garda') {
        gardaMarkersVisible = markersVisibleFlag;
    } else if (type === 'phar') {
        pharMarkersVisible = markersVisibleFlag;
    } else if (type === 'gps') {
        gpsMarkersVisible = markersVisibleFlag;
    } else if (type === 'health') {
        healthMarkersVisible = markersVisibleFlag;
    } else if (type === 'mow') {
        mowMarkersVisible = markersVisibleFlag;
    } else if (type === 'dentist') {
        dentistMarkersVisible = markersVisibleFlag;
    } else if (type === 'mabs') {
        mabsMarkersVisible = markersVisibleFlag;
    } else if (type === 'ncbi') {
        ncbiMarkersVisible = markersVisibleFlag;
    } else if (type === 'wheel') {
        wheelMarkersVisible = markersVisibleFlag;
    } else if (type === 'nursing') {
        nursingMarkersVisible = markersVisibleFlag;
    }
    // If markers are being hidden, close any open InfoWindow
    if (!markersVisibleFlag && currentlyOpenInfoWindow) {
        currentlyOpenInfoWindow.close();
        currentlyOpenInfoWindow = null; // Reset the open InfoWindow tracker
    }    
}

// Function to generate clickInfoWindowContent
function generateInfoWindowContent(location, markerType) {
    console.log("opening  med info" + markerType)

    let content = `<div class="infowindow ${markerType}"><strong>${location.Title__c || location.Name__c || 'Unknown'}</strong><br>`;

    if (location.Address__c) {
        content += 'Address: ' + location.Address__c + '<br>';
    }
    if (location.Website__c) {
        content += 'Website: <a href="' + location.Website__c + '" target="_blank">Visit Website</a><br>';
    }
    if (location.What__c) {
        content += 'Details: ' + location.What__c + '<br>';
    }
    if (location.Contact__c) {
        content += 'Contact: ' + location.Contact__c + '<br>';
    }
    if (location.Email__c) {
        content += 'Email1: <a href="mailto:' + location.Email__c + '">' + location.Email__c + '</a><br>';
    }
    if (location.Email2__c) {
        content += 'Email2: <a href="mailto:' + location.Email2__c + '">' + location.Email2__c + '</a><br>';
    }
    if (location.Phone__c) {
        content += 'Phone1: ' + location.Phone__c + '<br>';
    }
    if (location.Phone2__c) {
        content += 'Phone2: ' + location.Phone2__c + '<br>';
    }
    
    // Closing the div
    content += '</div>';

    return content;
}

