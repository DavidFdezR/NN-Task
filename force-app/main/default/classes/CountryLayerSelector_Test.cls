/**
 * @author David Fernandez
 * @date 02.09.2023.
 *
 * @description Test for the selector class
 */

@IsTest
private class CountryLayerSelector_Test {
    @IsTest
    private static void selectApiKeyByNameTest(){
        //Mocks
        //Given
        String environment = 'Development';

        //When
        Test.startTest();
        CountryLayer_API__mdt api = new CountryLayerSelector().selectApiKeyByName(environment);
        Test.stopTest();

        //Then
        System.assertNotEquals(null, api.API_KEY__c,'No value found in metadata');
    }

    @IsTest
    private static void selectExistingCountriesTest(){
        //Mocks
        //Given
        new SObjectBuilder(Country__c.SObjectType)
        .put(Country__c.Name,'Czech Republic')
        .put(Country__c.alpha2Code__c,'CZ')
        .put(Country__c.alpha3Code__c,'CZE')
        .put(Country__c.capital__c,'Prague')
        .create();

        //When
        Test.startTest();
        List<Country__c> existingCountries = new CountryLayerSelector().selectExistingCountries();
        Test.stopTest();

        //Then
        System.assertEquals(1, existingCountries.size(),'Different amount found in the database');
    }

}