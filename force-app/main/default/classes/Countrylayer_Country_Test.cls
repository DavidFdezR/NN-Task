/**
 * @author David Fernandez
 * @date 01.09.2023
 */
@IsTest
private class Countrylayer_Country_Test {

    // This test method should give 100% coverage
    @IsTest
    private static void testParse() {
        String json = '{'+
                '        \"name\": \"Afghanistan\",'+
                '        \"topLevelDomain\": ['+
                '            \".af\"'+
                '        ],'+
                '        \"alpha2Code\": \"AF\",'+
                '        \"alpha3Code\": \"AFG\",'+
                '        \"callingCodes\": ['+
                '            \"93\"'+
                '        ],'+
                '        \"capital\": \"Kabul\",'+
                '        \"altSpellings\": ['+
                '            \"AF\",'+
                '            \"Afġānistān\"'+
                '        ],'+
                '        \"region\": \"Asia\",'+
                '        \"subregion\": \"Southern Asia\",'+
                '        \"population\": 27657145,'+
                '        \"latlng\": ['+
                '            33,'+
                '            65'+
                '        ],'+
                '        \"demonym\": \"Afghan\",'+
                '        \"area\": 652230,'+
                '        \"gini\": 27.8,'+
                '        \"timezones\": ['+
                '            \"UTC+04:30\"'+
                '        ],'+
                '        \"borders\": ['+
                '            \"IRN\",'+
                '            \"PAK\",'+
                '            \"TKM\",'+
                '            \"UZB\",'+
                '            \"TJK\",'+
                '            \"CHN\"'+
                '        ],'+
                '        \"nativeName\": \"افغانستان\",'+
                '        \"numericCode\": \"004\",'+
                '        \"currencies\": ['+
                '            {'+
                '                \"code\": \"AFN\",'+
                '                \"name\": \"Afghan afghani\",'+
                '                \"symbol\": \"؋\"'+
                '            }'+
                '        ],'+
                '        \"languages\": ['+
                '            {'+
                '                \"iso639_1\": \"ps\",'+
                '                \"iso639_2\": \"pus\",'+
                '                \"name\": \"Pashto\",'+
                '                \"nativeName\": \"پښتو\"'+
                '            },'+
                '            {'+
                '                \"iso639_1\": \"uz\",'+
                '                \"iso639_2\": \"uzb\",'+
                '                \"name\": \"Uzbek\",'+
                '                \"nativeName\": \"Oʻzbek\"'+
                '            },'+
                '            {'+
                '                \"iso639_1\": \"tk\",'+
                '                \"iso639_2\": \"tuk\",'+
                '                \"name\": \"Turkmen\",'+
                '                \"nativeName\": \"Türkmen\"'+
                '            }'+
                '        ],'+
                '        \"translations\": {'+
                '            \"br\": \"Afeganistão\",'+
                '            \"de\": \"Afghanistan\",'+
                '            \"es\": \"Afganistán\",'+
                '            \"fa\": \"افغانستان\",'+
                '            \"fr\": \"Afghanistan\",'+
                '            \"hr\": \"Afganistan\",'+
                '            \"it\": \"Afghanistan\",'+
                '            \"ja\": \"アフガニスタン\",'+
                '            \"nl\": \"Afghanistan\",'+
                '            \"pt\": \"Afeganistão\"'+
                '        },'+
                '        \"flag\": \"https://restcountries.eu/data/afg.svg\",'+
                '        \"regionalBlocs\": ['+
                '            {'+
                '                \"acronym\": \"SAARC\",'+
                '                \"name\": \"South Asian Association for Regional Cooperation\"'+
                '            }'+
                '        ],'+
                '        \"cioc\": \"AFG\"'+
                '    }';
        Countrylayer_Country r = Countrylayer_Country.parse(json);
        System.assert(r != null);
        System.assert(r.get('alpha2Code')!= null);

        json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
        Countrylayer_Country.Languages objLanguages = new Countrylayer_Country.Languages(System.JSON.createParser(json));
        System.assert(objLanguages != null);
        System.assert(objLanguages.iso639_1 == null);
        System.assert(objLanguages.iso639_2 == null);
        System.assert(objLanguages.name == null);
        System.assert(objLanguages.nativeName == null);

        json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
        Countrylayer_Country objCountrylayer_Country = new Countrylayer_Country(System.JSON.createParser(json));
        System.assert(objCountrylayer_Country != null);
        System.assert(objCountrylayer_Country.name == null);
        System.assert(objCountrylayer_Country.topLevelDomain == null);
        System.assert(objCountrylayer_Country.alpha2Code == null);
        System.assert(objCountrylayer_Country.alpha3Code == null);
        System.assert(objCountrylayer_Country.callingCodes == null);
        System.assert(objCountrylayer_Country.capital == null);
        System.assert(objCountrylayer_Country.altSpellings == null);
        System.assert(objCountrylayer_Country.region == null);
        System.assert(objCountrylayer_Country.subregion == null);
        System.assert(objCountrylayer_Country.population == null);
        System.assert(objCountrylayer_Country.latlng == null);
        System.assert(objCountrylayer_Country.demonym == null);
        System.assert(objCountrylayer_Country.area == null);
        System.assert(objCountrylayer_Country.gini == null);
        System.assert(objCountrylayer_Country.timezones == null);
        System.assert(objCountrylayer_Country.borders == null);
        System.assert(objCountrylayer_Country.nativeName == null);
        System.assert(objCountrylayer_Country.numericCode == null);
        System.assert(objCountrylayer_Country.currencies == null);
        System.assert(objCountrylayer_Country.languages == null);
        System.assert(objCountrylayer_Country.translations == null);
        System.assert(objCountrylayer_Country.flag == null);
        System.assert(objCountrylayer_Country.regionalBlocs == null);
        System.assert(objCountrylayer_Country.cioc == null);

        json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
        Countrylayer_Country.Translations objTranslations = new Countrylayer_Country.Translations(System.JSON.createParser(json));
        System.assert(objTranslations != null);
        System.assert(objTranslations.br == null);
        System.assert(objTranslations.de == null);
        System.assert(objTranslations.es == null);
        System.assert(objTranslations.fa == null);
        System.assert(objTranslations.fr == null);
        System.assert(objTranslations.hr == null);
        System.assert(objTranslations.it == null);
        System.assert(objTranslations.ja == null);
        System.assert(objTranslations.nl == null);
        System.assert(objTranslations.pt == null);

        json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
        Countrylayer_Country.RegionalBlocs objRegionalBlocs = new Countrylayer_Country.RegionalBlocs(System.JSON.createParser(json));
        System.assert(objRegionalBlocs != null);
        System.assert(objRegionalBlocs.acronym == null);
        System.assert(objRegionalBlocs.name == null);

        json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
        Countrylayer_Country.Currencies objCurrencies = new Countrylayer_Country.Currencies(System.JSON.createParser(json));
        System.assert(objCurrencies != null);
        System.assert(objCurrencies.code == null);
        System.assert(objCurrencies.name == null);
        System.assert(objCurrencies.symbol == null);
    }
}