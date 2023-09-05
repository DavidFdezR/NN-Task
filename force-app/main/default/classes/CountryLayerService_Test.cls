/**
 * @author David Fernandez
 * @date 02.09.2023
 *
 * @description
 */

@IsTest
private class CountryLayerService_Test {
    public static final String APIKEY = 'XXXXXXXX-XXXXX';
    @IsTest
    private static void getApiValueTest() {
        //Given
        CountryLayer_API__mdt recordValue = (CountryLayer_API__mdt) new SObjectBuilder(CountryLayer_API__mdt.SObjectType)
                .put(CountryLayer_API__mdt.API_KEY__c, APIKEY)
                .build().getRecord();

        //Mocks
        GenericStub stub = new GenericStub();
        stub = stub.forMethod('selectApiKeyByName')
                .thatReturns(recordValue);

        CountryLayerSelector selectorMock = (CountryLayerSelector) Test.createStub(CountryLayerSelector.class, stub);
        CountryLayerService service = new CountryLayerService();
        service.countryLayerSelectorImpl = selectorMock;

        //When
        Test.startTest();
        String result = service.getApiValue();
        Test.stopTest();

        //Then
        System.assertEquals(result, apikey, 'Wrong api key returned');
    }

    @IsTest
    private static void getCountriesInfo() {
        //Given
        CountryLayer_API__mdt recordValue = (CountryLayer_API__mdt) new SObjectBuilder(CountryLayer_API__mdt.SObjectType)
                .put(CountryLayer_API__mdt.API_KEY__c, APIKEY)
                .build().getRecord();
        String jsonBody = '[{ "name": "Czech Republic","topLevelDomain": [".cz"],"alpha2Code": "CZ", "alpha3Code": "CZE",' +
                ' "callingCodes": ["420"], "capital": "Prague", "altSpellings": ["CZ","Česká republika", "Česko"],' +
                '"region": "Europe" }]';

        //Mocks
        HttpCalloutMockImpl calloutMockImpl = new HttpCalloutMockImpl();
        calloutMockImpl.responseBody = jsonBody;

        Test.setMock(HttpCalloutMock.class, calloutMockImpl);
        GenericStub stub = new GenericStub();
        stub = stub.forMethod('selectApiKeyByName')
                .thatReturns(recordValue);

        CountryLayerSelector selectorMock = (CountryLayerSelector) Test.createStub(CountryLayerSelector.class, stub);
        CountryLayerService service = new CountryLayerService();
        service.countryLayerSelectorImpl = selectorMock;

        //When
        Test.startTest();
        Map<String, Countrylayer_Country> foundCountries = service.getCountriesInfo();
        Test.stopTest();

        System.assert(foundCountries.containsKey('Czech Republic'));
    }
    @IsTest
    private static void isModifiedCountry_Equal_Test() {
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
                .build().getRecord();

        Countrylayer_Country retrievedCzechCountry = Countrylayer_Country.parse(jsonBody);

        CountryLayerService service = new CountryLayerService();
        //When
        Test.startTest();
        Country__c verified = service.isModifiedCountry(czechCountry, retrievedCzechCountry);
        Test.stopTest();

        System.assertEquals(verified, null, 'Objects are different');
    }
    @IsTest
    private static void isModifiedCountry_Diff_Test() {
        //Given
        String jsonBody = '[{ "name": "Czech Republic","topLevelDomain": [".cz"],"alpha2Code": "CZ", "alpha3Code": "CZE",' +
                ' "callingCodes": ["420"], "capital": "Ostrava", "altSpellings": ["CZ","Česká republika", "Česko"],' +
                '"region": "Europe" }]';
        Country__c czechCountry = (Country__c) new SObjectBuilder(Country__c.SObjectType)
                .put(Country__c.Name, 'Czech Republic')
                .put(Country__c.alpha2Code__c, 'CZ')
                .put(Country__c.alpha3Code__c, 'CZE')
                .put(Country__c.capital__c, 'Prague')
                .put(Country__c.Region__c, 'Europe')
                .build().getRecord();

        Countrylayer_Country retrievedCzechCountry = Countrylayer_Country.parse(jsonBody);

        CountryLayerService service = new CountryLayerService();
        //When
        Test.startTest();
        Country__c verified = service.isModifiedCountry(czechCountry, retrievedCzechCountry);
        Test.stopTest();

        System.assertEquals(verified.capital__c, 'Ostrava', 'Objects are the same');
    }
    @IsTest
    private static void getExistingCountries_Test() {
        //Given
        CountryLayer_API__mdt recordValue = (CountryLayer_API__mdt) new SObjectBuilder(CountryLayer_API__mdt.SObjectType)
                .put(CountryLayer_API__mdt.API_KEY__c, APIKEY)
                .build().getRecord();
        String jsonBody = '[{ "name": "Czech Republic","topLevelDomain": [".cz"],"alpha2Code": "CZ", "alpha3Code": "CZE",' +
                ' "callingCodes": ["420"], "capital": "Prague", "altSpellings": ["CZ","Česká republika", "Česko"],' +
                '"region": "Europe" }]';

        //Mocks
        HttpCalloutMockImpl calloutMockImpl = new HttpCalloutMockImpl();
        calloutMockImpl.responseBody = jsonBody;

        Test.setMock(HttpCalloutMock.class, calloutMockImpl);
        GenericStub stub = new GenericStub();
        stub = stub.forMethod('selectApiKeyByName')
                .thatReturns(recordValue);
        stub = stub.forMethod('selectExistingCountries')
                .thatReturns(new List<Country__c>());


        CountryLayerSelector selectorMock = (CountryLayerSelector) Test.createStub(CountryLayerSelector.class, stub);
        CountryLayerService service = new CountryLayerService();
        service.countryLayerSelectorImpl = selectorMock;

        //When
        Test.startTest();
        List<Country__c> existingCountries = service.getExistingCountries();
        Test.stopTest();

        //Then
        /*This needs to be asserted this way because of the stubbing,
        with another framework like apex commons it can be mocked separately*/
        System.assert(existingCountries.size() ==0,'The method is not being stubbed');
    }

    public class HttpCalloutMockImpl implements HttpCalloutMock {
        public Boolean throwError;
        public String responseBody ;
        public HTTPResponse respond(HTTPRequest req) {
            Assert.areEqual(
                    'callout:CountryLayer?access_key=' + APIKEY,
                    req.getEndpoint()
            );
            Assert.areEqual('GET', req.getMethod());
            Assert.areEqual(
                    'application/json;charset=UTF-8',
                    req.getHeader('Content-Type')
            );
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