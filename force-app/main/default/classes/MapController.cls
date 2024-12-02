//copyright © 2024 Stefan Dodds @ stefandodds.ie, All rights reserved

public class MapController {

    // Properties to hold locations for OPs, OPTBM, and OPTBRE
       public transient List<OPs__c> OPACT { get; set; } // Holds OPs locations with status 'To be matched'
       public transient List<OPs__c> OPTBM { get; set; } // Holds OPs locations with status 'Matched'
       public transient List<OPs__c> OPTBRE { get; set; } // Holds OPs locations with status 'Re-match'
   
       // Properties to hold locations for Volunteers: VOLA, VOLFtAc, and VOLTBM
       public transient List<Volunteers__c> VOLA { get; set; }  // Volunteers with status 'Active'
       public transient List<Volunteers__c> VOLFtAc { get; set; }  // Volunteers with status 'Full-Time Active'
       public transient List<Volunteers__c> VOLTBM { get; set; }  // Volunteers with status 'To Be Matched'
       
       // Query to fetch the necessary fields including Geolocation
       public transient List<Alz__c> alz { get; set; }
       public transient List<PrimaryCare__c> primary { get; set; }
       public transient List<Chime__c> chime { get; set; }
       public transient List<Council__c> council { get; set; }
       public transient List<Hospitals__c> hospitals { get; set; }
       public transient List<Garda__c> garda { get; set; }
       public transient List<FRC__c> frc { get; set; }
       public transient List<Phar__c> phar { get; set; }
       public transient List<Health__c> health { get; set; }
       public transient List<Nursing__c> nursing { get; set; }
       public transient List<Dentist__c> dentist { get; set; }
       public transient List<Wheel__c> wheel { get; set; } 
       public transient List<NCBI__c> ncbi { get; set; }
       public transient List<MABS__c> mabs { get; set; }
       public transient List<MOW__c> mow { get; set; }   
        
       
       public String gpsLocations { get; set; }
       public String dentistLocations { get; set; }
   
       // Public variable to be accessible in Visualforce
       public List<OPs__c> OPchns { get; set; }
       public Set<Decimal> uniqueChns { get; set; }
       
       public String selectedChn { get; set; }  // Add this line to store the selected CHN value
       public List<SelectOption> scOptions { get; set; }
   
       // Constructor to fetch the data
       public MapController() {
       
           OPchns = new List<OPs__c>();  // Public variable
           uniqueChns = new Set<Decimal>(); // Assuming CHN__c is Decimal
           
           
           scOptions = new List<SelectOption>();
   
           // Fetch all records from OPs__c ordered by CHN__c
           List<OPs__c> allOPCHN = [SELECT Id, CHN__c FROM OPs__c ORDER BY CHN__c];
   
           // Variable to keep track of the last added CHN__c
           Decimal lastCHN = null;
   
           // Loop through the records to filter and add unique CHN__c values
           for (OPs__c op : allOPCHN) {
               if (op.CHN__c != lastCHN) { // Add only if the current CHN__c is different from the last one
                   uniqueChns.add(op.CHN__c);   
                   OPchns.add(op);  // Store the OPs__c record in the public list
                   lastCHN = op.CHN__c;  // Update the last added CHN__c value
               }
           }  
           
           
           
   
   
           
           // Fetch OPs records from the custom object 'OPs__c' where Status__c is 'To be matched'
           List<OPs__c> allOPACT = [SELECT Id, Name, First_Name__c, Surname__c, CHN__c, SC__c, LatLon__Latitude__s, LatLon__Longitude__s, 
                                     Status__c, Pets__c, Sex__c, Smoker__c, Age__c 
                                     FROM OPs__c 
                                     WHERE Status__c = 'Matched'];
   
           // Filter out any records with null geolocation values in the Apex code
           OPACT = new List<OPs__c>();
           for (OPs__c op : allOPACT) {
               if (op.LatLon__Latitude__s != null && op.LatLon__Longitude__s != null) {
                   OPACT.add(op);
               }
           }
   
           // Fetch OPs records where Status__c is 'Matched' (now OPTBM)
           List<OPs__c> allOPTBM = [SELECT Id, Name, First_Name__c, Surname__c, CHN__c, SC__c, LatLon__Latitude__s, LatLon__Longitude__s,
                                     Status__c, Pets__c, Sex__c, Smoker__c, Age__c
                                     FROM OPs__c 
                                     WHERE Status__c = 'To be matched'];
   
           OPTBM = new List<OPs__c>();
           for (OPs__c pc : allOPTBM) {
               if (pc.LatLon__Latitude__s != null && pc.LatLon__Longitude__s != null) {
                   OPTBM.add(pc);
               }
           }
   
           // Fetch OPs records where Status__c is 'Re-match' (now OPTBRE)
           List<OPs__c> allOPTBRE = [SELECT Id, Name, First_Name__c, Surname__c, CHN__c, SC__c, LatLon__Latitude__s, LatLon__Longitude__s, 
                                      Status__c, Pets__c, Sex__c, Smoker__c, Age__c
                                      FROM OPs__c 
                                      WHERE Status__c = 'Re-match'];
   
           OPTBRE = new List<OPs__c>();
           for (OPs__c ch : allOPTBRE) {
               if (ch.LatLon__Latitude__s != null && ch.LatLon__Longitude__s != null) {
                   OPTBRE.add(ch);
               }
           }
   
           // Fetch Volunteers records where Status__c is 'Active' (for VOLA)
           List<Volunteers__c> allVOLA = [SELECT Id, Name, First_Name__c, Surname__c, LatLon__Latitude__s, LatLon__Longitude__s, 
                                         Status__c, Pets__c, Sex__c, Smoking__c, Age__c
                                         FROM Volunteers__c 
                                         WHERE Status__c = 'Active'];
   
           VOLA = new List<Volunteers__c>();
           for (Volunteers__c v : allVOLA) {
               if (v.LatLon__Latitude__s != null && v.LatLon__Longitude__s != null) {
                   VOLA.add(v);
               }
           }
   
           // Fetch Volunteers records where Status__c is 'Full-Time Active' (for VOLFtAc)
           List<Volunteers__c> allVOLFtAc = [SELECT Id, Name, First_Name__c, Surname__c, LatLon__Latitude__s, LatLon__Longitude__s, 
                                            Status__c, Pets__c, Sex__c, Smoking__c, Age__c
                                            FROM Volunteers__c 
                                            WHERE Status__c = 'FtAc'];
   
           VOLFtAc = new List<Volunteers__c>();
           for (Volunteers__c v : allVOLFtAc) {
               if (v.LatLon__Latitude__s != null && v.LatLon__Longitude__s != null) {
                   VOLFtAc.add(v);
               }
           }
   
           // Fetch Volunteers records where Status__c is 'To Be Matched' (for VOLTBM)
           List<Volunteers__c> allVOLTBM = [SELECT Id, Name, First_Name__c, Surname__c, LatLon__Latitude__s, LatLon__Longitude__s, 
                                           Status__c, Pets__c, Sex__c, Smoking__c, Age__c
                                           FROM Volunteers__c 
                                           WHERE Status__c = 'TBM'];
   
           VOLTBM = new List<Volunteers__c>();
           for (Volunteers__c v : allVOLTBM) {
               if (v.LatLon__Latitude__s != null && v.LatLon__Longitude__s != null) {
                   VOLTBM.add(v);
               }
           }
           
           // Fetch Alz records with geolocation data (the missing query)
           List<Alz__c> allAlz = [SELECT Id, Title__c, Address__c, Website__c, What__c, LatLng__Latitude__s, LatLng__Longitude__s, Contact__c, Email__c, Email2__c, Phone__c, Phone2__c
                                  FROM Alz__c];
   
           // Initialize the list for filtered locations
           alz = new List<Alz__c>();
   
           // Filter the records and log the Title__c field
           for (Alz__c v : allAlz) {
               if (v.LatLng__Latitude__s != null && v.LatLng__Longitude__s != null) {
                   System.debug('Alz Title__c: ' + v.Title__c);  // Log the Title__c field for debugging
                   alz.add(v);  // Add valid records to the filtered list
               }
           }     
           
       
           
           // Fetch Alz records with geolocation data (the missing query)
           List<Chime__c> allChime = [SELECT Id, Title__c, Address__c, Website__c, What__c, LatLng__Latitude__s, LatLng__Longitude__s
                                  FROM Chime__c];
   
           // Initialize the list for filtered locations
           chime = new List<Chime__c>();
   
           // Filter the records and log the Title__c field
           for (Chime__c v : allChime) {
               if (v.LatLng__Latitude__s != null && v.LatLng__Longitude__s != null) {
                   System.debug('Chime Title__c: ' + v.Title__c);  // Log the Title__c field for debugging
                   chime.add(v);  // Add valid records to the filtered list
               }
           }  
           
           // Fetch Council records with geolocation data (the missing query)
           List<Council__c> allCouncil = [SELECT Id, Title__c, Address__c, Other__c, Website__c, LatLng__Latitude__s, LatLng__Longitude__s
                                  FROM Council__c];
   
           // Initialize the list for filtered locations
           council = new List<Council__c>();
   
           // Filter the records and log the Title__c field
           for (Council__c v : allCouncil) {
               if (v.LatLng__Latitude__s != null && v.LatLng__Longitude__s != null) {
                   System.debug('Council Title__c: ' + v.Title__c);  // Log the Title__c field for debugging
                   council.add(v);  // Add valid records to the filtered list
               }
           }   
           
           // Fetch Alz records with geolocation data (the missing query)
           List<PrimaryCare__c> allPrimary = [SELECT Id, Title__c, Address__c, Eircode__c, Phone__c, Phone2__c, Website__c, What__c, LatLng__Latitude__s, LatLng__Longitude__s
                                  FROM PrimaryCare__c];
   
           // Initialize the list for filtered locations
           primary = new List<PrimaryCare__c>();
   
           // Filter the records and log the Title__c field
           for (PrimaryCare__c v : allPrimary) {
               if (v.LatLng__Latitude__s != null && v.LatLng__Longitude__s != null) {
                   System.debug('Primary Title__c: ' + v.Title__c);  // Log the Title__c field for debugging
                   primary.add(v);  // Add valid records to the filtered list
               }
           }        
           
           // Fetch Council records with geolocation data (the missing query)
           List<Hospitals__c> allHospitals = [SELECT Id, Title__c, Address__c, Website__c, LatLng__Latitude__s, LatLng__Longitude__s
                                  FROM Hospitals__c];
   
           // Initialize the list for filtered locations
           hospitals = new List<Hospitals__c>();
   
           // Filter the records and log the Title__c field
           for (Hospitals__c v : allHospitals) {
               if (v.LatLng__Latitude__s != null && v.LatLng__Longitude__s != null) {
                   System.debug('Hospitals Title__c: ' + v.Title__c);  // Log the Title__c field for debugging
                   hospitals.add(v);  // Add valid records to the filtered list
               }
           }    
           
           // Fetch Garda records with geolocation data (the missing query)
           List<Garda__c> allGarda = [SELECT Id, Title__c, Address__c, Other__c, Website__c, LatLng__Latitude__s, LatLng__Longitude__s
                                  FROM Garda__c];
   
           // Initialize the list for filtered locations
           garda = new List<Garda__c>();
   
           // Filter the records and log the Title__c field
           for (Garda__c v : allGarda) {
               if (v.LatLng__Latitude__s != null && v.LatLng__Longitude__s != null) {
                   System.debug('Garda Title__c: ' + v.Title__c);  // Log the Title__c field for debugging
                   garda.add(v);  // Add valid records to the filtered list
               }
           }    
           
           
           // Fetch Garda records with geolocation data (the missing query)
           List<Phar__c> allPhar = [SELECT Id, Title__c, Address__c, LatLng__Latitude__s, LatLng__Longitude__s
                                  FROM Phar__c];
   
           // Initialize the list for filtered locations
           phar = new List<Phar__c>();
   
           // Filter the records and log the Title__c field
           for (Phar__c v : allPhar) {
               if (v.LatLng__Latitude__s != null && v.LatLng__Longitude__s != null) {
                   System.debug('Phar Title__c: ' + v.Title__c);  // Log the Title__c field for debugging
                   phar.add(v);  // Add valid records to the filtered list
               }
           }   
           
           // Fetch Garda records with geolocation data (the missing query)
           List<Health__c> allHealth = [SELECT Id, Title__c, Address__c, LatLng__Latitude__s, LatLng__Longitude__s
                                  FROM Health__c];
   
           // Initialize the list for filtered locations
           health = new List<Health__c>();
   
           // Filter the records and log the Title__c field
           for (Health__c v : allHealth) {
               if (v.LatLng__Latitude__s != null && v.LatLng__Longitude__s != null) {
                   System.debug('Health Title__c: ' + v.Title__c);  // Log the Title__c field for debugging
                   health.add(v);  // Add valid records to the filtered list
               }
           }    
   
           // Fetch Garda records with geolocation data (the missing query)
           List<MOW__c> allMOW = [SELECT Id, Title__c, Address__c, LatLng__Latitude__s, LatLng__Longitude__s
                                  FROM MOW__c];
   
           // Initialize the list for filtered locations
           mow = new List<MOW__c>();
   
           // Filter the records and log the Title__c field
           for (MOW__c v : allMOW) {
               if (v.LatLng__Latitude__s != null && v.LatLng__Longitude__s != null) {
                   System.debug('MOW Title__c: ' + v.Title__c);  // Log the Title__c field for debugging
                   mow.add(v);  // Add valid records to the filtered list
               }
           }         
           
           // Fetch Garda records with geolocation data (the missing query)
           List<MABS__c> allMABS = [SELECT Id, Title__c, Address__c, LatLng__Latitude__s, LatLng__Longitude__s
                                  FROM MABS__c];
   
           // Initialize the list for filtered locations
           mabs = new List<MABS__c>();
   
           // Filter the records and log the Title__c field
           for (MABS__c v : allMABS) {
               if (v.LatLng__Latitude__s != null && v.LatLng__Longitude__s != null) {
                   System.debug('MABS Title__c: ' + v.Title__c);  // Log the Title__c field for debugging
                   mabs.add(v);  // Add valid records to the filtered list
               }
           }        
           
           // Fetch Garda records with geolocation data (the missing query)
           List<NCBI__c> allNCBI = [SELECT Id, Title__c, Address__c, LatLng__Latitude__s, LatLng__Longitude__s
                                  FROM NCBI__c];
   
           // Initialize the list for filtered locations
           ncbi = new List<NCBI__c>();
   
           // Filter the records and log the Title__c field
           for (NCBI__c v : allNCBI) {
               if (v.LatLng__Latitude__s != null && v.LatLng__Longitude__s != null) {
                   System.debug('NCBI Title__c: ' + v.Title__c);  // Log the Title__c field for debugging
                   ncbi.add(v);  // Add valid records to the filtered list
               }
           }        
           
           // Fetch Garda records with geolocation data (the missing query)
           List<Wheel__c> allWheel = [SELECT Id, Title__c, Address__c, LatLng__Latitude__s, LatLng__Longitude__s
                                  FROM Wheel__c];
   
           // Initialize the list for filtered locations
           wheel = new List<Wheel__c>();
   
           // Filter the records and log the Title__c field
           for (Wheel__c v : allWheel) {
               if (v.LatLng__Latitude__s != null && v.LatLng__Longitude__s != null) {
                   System.debug('Wheel Title__c: ' + v.Title__c);  // Log the Title__c field for debugging
                   wheel.add(v);  // Add valid records to the filtered list
               }
           }          
           
           // Fetch Garda records with geolocation data (the missing query)
           List<Nursing__c> allNursing = [SELECT Id, Title__c, Address__c, LatLng__Latitude__s, LatLng__Longitude__s
                                  FROM Nursing__c];
   
           // Initialize the list for filtered locations
           nursing = new List<Nursing__c>();
   
           // Filter the records and log the Title__c field
           for (Nursing__c v : allNursing) {
               if (v.LatLng__Latitude__s != null && v.LatLng__Longitude__s != null) {
                   System.debug('Nursing Title__c: ' + v.Title__c);  // Log the Title__c field for debugging
                   nursing.add(v);  // Add valid records to the filtered list
               }
           }                   
           
           fetchGPSLocations(); // Fetch GPS data in the constructor       
           fetchDentistLocations(); // Fetch GPS data in the constructor    
           
      
           // Debugging output to check the number of records fetched
           System.debug('OPs Locations: ' + OPACT.size());
           System.debug('OPTBM Locations: ' + OPTBM.size());
           System.debug('OPTBRE Locations: ' + OPTBRE.size());
           System.debug('VOLA Locations: ' + VOLA.size());
           System.debug('VOLFtAc Locations: ' + VOLFtAc.size());
           System.debug('VOLTBM Locations: ' + VOLTBM.size());
           System.debug('Alz Locations: ' + alz.size());
           System.debug('Primary Locations: ' + primary.size());
           System.debug('Chime Locations: ' + chime.size());
           System.debug('Council Locations: ' + council.size());
           System.debug('Hospitals Locations: ' + hospitals.size());
           System.debug('Garda Locations: ' + garda.size());
           System.debug('Phar Locations: ' + phar.size());
           System.debug('Health Locations: ' + health.size());
           System.debug('MOW Locations: ' + mow.size());
           System.debug('MABS Locations: ' + mabs.size());
           
                  
       }
       
       // Method to return the unique CHN__c values as SelectOptions for the dropdown
       public List<SelectOption> getChnOptions() {
           List<SelectOption> options = new List<SelectOption>();
           options.add(new SelectOption('', 'Select CHN')); // Default empty option
   
           // Add unique CHN__c values to the options list
           for (Decimal chn : uniqueChns) {
               options.add(new SelectOption(String.valueOf(chn), String.valueOf(chn)));
           }
           return options;
       }
       
   
       
   public void fetchSCsForSelectedChn() {
       if (selectedChn != null && selectedChn != '') {
           try {
               // Convert the selected CHN (which is a String) to Decimal
               Decimal chnDecimal = Decimal.valueOf(selectedChn); 
               
               // Query OPs records with the matching CHN and order by SC__c
               List<OPs__c> opsWithSCs = [SELECT Id, SC__c 
                                          FROM OPs__c 
                                          WHERE CHN__c = :chnDecimal 
                                          ORDER BY SC__c];
                                          
               // Populate the SC dropdown options
               scOptions = new List<SelectOption>();
               scOptions.add(new SelectOption('', 'Select SC')); // Default option
               for (OPs__c op : opsWithSCs) {
                   if(op.SC__c != null) {
                       scOptions.add(new SelectOption(op.SC__c, op.SC__c));
                   }
               }
           } catch (Exception e) {
               System.debug('Error while fetching SCs for CHN: ' + e.getMessage());
           }
       }
   }
   
       
       
       // Method to fetch SCs based on the selected CHN
       @RemoteAction
       public static List<SelectOption> getSCOptions(String selectedChn) {
           List<SelectOption> options = new List<SelectOption>();
           options.add(new SelectOption('', 'Select SC')); // Default empty option
   
           if (selectedChn != null && selectedChn != '') {
               // Query to fetch OPs with the selected CHN and order by SC
               Decimal chnDecimal = Decimal.valueOf(selectedChn);
               
               List<OPs__c> scList = [SELECT SC__c FROM OPs__c WHERE CHN__c = :chnDecimal ORDER BY SC__c];
               
               Set<String> uniqueScSet = new Set<String>();
   
               // Ensure only unique SCs are added to the options
               for (OPs__c op : scList) {
                   if (op.SC__c != null && !uniqueScSet.contains(op.SC__c)) {
                       uniqueScSet.add(op.SC__c);
                       options.add(new SelectOption(op.SC__c, op.SC__c)); // Ensure both value and label are SC__c
                   }
               }
           }
   
           return options;
       }    
       
       // Method to fetch GPS data from the external CSV file
       public void fetchGPSLocations() {
           HttpRequest req = new HttpRequest();
           req.setEndpoint('https://data.gov.ie/dataset/e193e75c-8f0d-4284-9a7e-5c9e1e0235e3/resource/db49a128-7a83-48d5-83c6-5015c19eada9/download/gps.csv');
           req.setMethod('GET');
           req.setTimeout(2000); // Set timeout to avoid long delays
   
           Http http = new Http();
           HttpResponse res;
   
           try {
               res = http.send(req);
   
               if (res.getStatusCode() == 200) {
                   gpsLocations = res.getBody(); // Store GPS data
                   System.debug('Successfully fetched GPS data: ' + gpsLocations);
               } else {
                   System.debug('Error fetching GPS data: ' + res.getStatusCode() + ' - ' + res.getStatus());
                   gpsLocations = 'Error fetching GPS data';
               }
           } catch (Exception e) {
               System.debug('Exception during GPS data fetch: ' + e.getMessage());
               gpsLocations = 'Error during GPS data fetch: ' + e.getMessage();
           }
       }
   
       @RemoteAction
       public static String getGPSLocationsAsJSON() {
           ServLocationController controller = new ServLocationController();
           System.debug('GPS Locations Data: ' + controller.gpsLocations);
       
           if (String.isNotBlank(controller.gpsLocations)) {
               return controller.gpsLocations;
           } else {
               return '[{"Latitude": "51.5", "Longitude": "-0.1", "Name": "Test Location"}]';
           }
       }
       
       // Method to fetch GPS data from the external CSV file
       public void fetchDentistLocations() {
           HttpRequest req = new HttpRequest();
           req.setEndpoint('https://data.ehealthireland.ie/dataset/56fa4cee-e17a-40e0-8a51-bb408b00ea1e/resource/b6b58896-c8d8-4824-8eac-b5d2191d7379/download/dental_practices.csv');
           req.setMethod('GET');
           req.setTimeout(2000); // Set timeout to avoid long delays
   
           Http http = new Http();
           HttpResponse res;
   
           try {
               res = http.send(req);
   
               if (res.getStatusCode() == 200) {
                   dentistLocations = res.getBody(); // Store GPS data
                   System.debug('Successfully fetched Dentist data: ' + dentistLocations);
               } else {
                   System.debug('Error fetching Dental data: ' + res.getStatusCode() + ' - ' + res.getStatus());
                   dentistLocations = 'Error fetching Dentist data';
               }
           } catch (Exception e) {
               System.debug('Exception during Dentist data fetch: ' + e.getMessage());
               dentistLocations = 'Error during Dentist data fetch: ' + e.getMessage();
           }
       }
   
       @RemoteAction
       public static String getDentistLocationsAsJSON() {
           CombinedLocationController controller = new CombinedLocationController(); // Create instance
           System.debug('Dentist Locations Data: ' + controller.dentistLocations);
       
           if (String.isNotBlank(controller.dentistLocations)) {
               return controller.dentistLocations;
           } else {
               return '[{"Latitude": "51.5", "Longitude": "-0.1", "Name": "Test Location"}]';
           }
       }
       
          
   
       // Method to return the OPACT data as a JSON string
       public String getnewOPACTAsJSON() {
           return JSON.serialize(OPACT);
       }
   
       // Method to return the OPTBM data as a JSON string
       public String getOPTBMAsJSON() {
           return JSON.serialize(OPTBM);
       }
   
       // Method to return the OPTBRE data as a JSON string
       public String getOPTBREAsJSON() {
           return JSON.serialize(OPTBRE);
       }
   
       // Method to return the VOLA data as a JSON string
       public String getVOLAAsJSON() {
           return JSON.serialize(VOLA);
       }
   
       // Method to return the VOLFtAc data as a JSON string
       public String getVOLFtAcAsJSON() {
           return JSON.serialize(VOLFtAc);
       }
   
       // Method to return the VOLTBM data as a JSON string
       public String getVOLTBMAsJSON() {
           return JSON.serialize(VOLTBM);
       }
   
       // Method to return the filtered Alz__c records as a JSON string
       public String getAlzAsJSON() {
           return JSON.serialize(alz);
       }  
       
       // Method to return the filtered Alz__c records as a JSON string
       public String getPrimaryAsJSON() {
           return JSON.serialize(primary);
       }      
       
       // Method to return the filtered Alz__c records as a JSON string
       public String getChimeAsJSON() {
           return JSON.serialize(chime);
       } 
       
       // Method to return the filtered Alz__c records as a JSON string
       public String getCouncilAsJSON() {
           return JSON.serialize(council);
       }     
       
       // Method to return the filtered Alz__c records as a JSON string
       public String getHospitalsAsJSON() {
           return JSON.serialize(hospitals);
       }          
       
       // Method to return the filtered Alz__c records as a JSON string
       public String getGardaAsJSON() {
           return JSON.serialize(garda);
       }    
       
       // Method to return the filtered Alz__c records as a JSON string
       public String getPharAsJSON() {
           return JSON.serialize(phar);
       }     
       
       // Method to return the filtered Alz__c records as a JSON string
       public String getHealthAsJSON() {
           return JSON.serialize(health);
       }      
       
       // Method to return the filtered Alz__c records as a JSON string
       public String getMOWAsJSON() {
           return JSON.serialize(mow);
       } 
       
       // Method to return the filtered Alz__c records as a JSON string
       public String getMABSAsJSON() {
           return JSON.serialize(mabs);
       }    
       
       // Method to return the filtered Alz__c records as a JSON string
       public String getNCBIAsJSON() {
           return JSON.serialize(ncbi);
       }  
       
       // Method to return the filtered Alz__c records as a JSON string
       public String getWheelAsJSON() {
           return JSON.serialize(wheel);
       }      
           
       // Method to return the filtered Alz__c records as a JSON string
       public String getNursingAsJSON() {
           return JSON.serialize(nursing);
       }
               
   }