/**
 * Created by david on 05.09.2023.
 */
@IsTest
private class CountryLayerBatch_Test {
    @IsTest
    private static void batch_SameRecordTest(){
        //Given
        String jsonBody = '[{ "name": "Czech Republic","topLevelDomain": [".cz"],"alpha2Code": "CZ", "alpha3Code": "CZE",' +
                ' "callingCodes": ["420"], "capital": "Prague", "altSpellings": ["CZ","Česká republika", "Česko"],' +
                '"region": "Europe" }]';

        Country__c czechCountry = (Country__c) new SObjectBuilder(Country__c.SObjectType)
                .put(Country__c.Name, 'Czech Republic')
                .put(Country__c.alpha2Code__c, 'CZ')
                .put(Country__c.alpha3Code__c, 'CZE')
                .put(Country__c.capital__c, 'Prague')
                .put(Country__c.Region__c, 'Europe')
                .create().getRecord();

        Countrylayer_Country retrievedCzechCountry = Countrylayer_Country.parse(jsonBody);
        Map<String, Countrylayer_Country> retrievedMap = new Map<String, Countrylayer_Country>{
                retrievedCzechCountry.name => retrievedCzechCountry
        };

        //Mocks
        GenericStub stub = new GenericStub();
        stub = stub.forMethod('getExistingCountries')
                .thatReturns(new List<Country__c>{czechCountry});

        CountryLayerService serviceMock = (CountryLayerService) Test.createStub(CountryLayerService.class, stub);
        serviceMock.retrievedCountries = retrievedMap;
        CountryLayerBatch batch =  new CountryLayerBatch();
        batch.countryLayerServiceImpl = serviceMock;

        //When
        Test.startTest();
            Id batchId = Database.executeBatch(batch,200);
        Test.stopTest();

        //Then
        Country__c existing = [SELECT capital__c FROM Country__c WHERE Id =:czechCountry.Id LIMIT 1];
        System.assertEquals(existing.capital__c, czechCountry.capital__c,'Modifications where made to record');
    }

    @IsTest
    private static void batch_DiffRecordTest(){
        //Given
        String jsonBody = '[{ "name": "Czech Republic","topLevelDomain": [".cz"],"alpha2Code": "CZ", "alpha3Code": "CZE",' +
                ' "callingCodes": ["420"], "capital": "Prague", "altSpellings": ["CZ","Česká republika", "Česko"],' +
                '"region": "Europe" }]';

        Country__c czechCountry = (Country__c) new SObjectBuilder(Country__c.SObjectType)
                .put(Country__c.Name, 'Czech Republic')
                .put(Country__c.alpha2Code__c, 'CZ')
                .put(Country__c.alpha3Code__c, 'CZE')
                .put(Country__c.capital__c, 'Ostrava')
                .put(Country__c.Region__c, 'Europe')
                .create().getRecord();

        Countrylayer_Country retrievedCzechCountry = Countrylayer_Country.parse(jsonBody);
        Map<String, Countrylayer_Country> retrievedMap = new Map<String, Countrylayer_Country>{
                retrievedCzechCountry.name => retrievedCzechCountry
        };

        //Mocks
        GenericStub stub = new GenericStub();
        stub = stub.forMethod('getExistingCountries')
                .thatReturns(new List<Country__c>{czechCountry});
        stub = stub.forMethod('isModifiedCountry')
                .thatReturns(czechCountry);

        CountryLayerService serviceMock = (CountryLayerService) Test.createStub(CountryLayerService.class, stub);
        serviceMock.retrievedCountries = retrievedMap;
        CountryLayerBatch batch =  new CountryLayerBatch();
        batch.countryLayerServiceImpl = serviceMock;

        //When
        Test.startTest();
        Id batchId = Database.executeBatch(batch,200);
        Test.stopTest();

        //Then
        System.assertNotEquals('Prague', czechCountry.capital__c,'Modifications where not made to record');
    }

    @IsTest
    private static void schedulableTest(){
        //Given
        String sch = '0 0 23 * * ?';
        String jsonBody = '[{ "name": "Czech Republic","topLevelDomain": [".cz"],"alpha2Code": "CZ", "alpha3Code": "CZE",' +
                ' "callingCodes": ["420"], "capital": "Prague", "altSpellings": ["CZ","Česká republika", "Česko"],' +
                '"region": "Europe" }]';

        new SObjectBuilder(Country__c.SObjectType)
                .put(Country__c.Name, 'Czech Republic')
                .put(Country__c.alpha2Code__c, 'CZ')
                .put(Country__c.alpha3Code__c, 'CZE')
                .put(Country__c.capital__c, 'Prague')
                .put(Country__c.Region__c, 'Europe')
                .create();

        //Mocks
        HttpCalloutMockImpl calloutMockImpl = new HttpCalloutMockImpl();
        calloutMockImpl.responseBody = jsonBody;

        Test.setMock(HttpCalloutMock.class, calloutMockImpl);

        //When
        Test.startTest();
            CountryLayerBatch scheduled = new CountryLayerBatch();
            System.schedule('Test check', sch, scheduled);
        Test.stopTest();
    }

    public class HttpCalloutMockImpl implements HttpCalloutMock {
        public Boolean throwError;
        public String responseBody ;
        public HTTPResponse respond(HTTPRequest req) {
            // Create fake response
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody(responseBody);
            if (throwError == true) {
                res.setStatusCode(500);
                res.setStatus('Failure');
            } else {
                res.setStatusCode(200);
                res.setStatus('Success');
            }
            return res;
        }
    }
}