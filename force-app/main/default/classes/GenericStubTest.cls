/**
 * @author David Fernandez
 * @date 15.07.2021
 *
 * @description Test class for GenericStub class
 */
@IsTest
private class GenericStubTest {

    private static final String TEST_METHOD_NAME = 'myMethod';
    private static final Object EXPECTED_RESULT = new Account();
    private static final Exception EXPECTED_EXCEPTION = new MathException('Test error message');

    private static GenericStub stub;
    static {
        stub = new GenericStub();
    }

    private static testMethod void testForMethod() {
        Test.startTest();
        stub.forMethod(TEST_METHOD_NAME);
        Test.stopTest();

        System.assertEquals(TEST_METHOD_NAME, stub.currentMethod, 'Invalid current method set.');
    }

    private static testMethod void testForAllMethods() {
        stub.currentMethod = 'some not-null value';

        Test.startTest();
        stub.forAllMethods();
        Test.stopTest();

        System.assertEquals(null, stub.currentMethod, 'Invalid current method set.');
    }

    private static testMethod void testThatReturns_forMethod() {
        Test.startTest();
        stub.forMethod(TEST_METHOD_NAME).thatReturns(EXPECTED_RESULT);
        Test.stopTest();

        System.assertEquals(1, stub.returnValues.size(), 'Invalid number of return values set.');
        System.assertEquals(EXPECTED_RESULT, stub.returnValues.get(TEST_METHOD_NAME), 'Invalid return value set.');
        System.assertEquals(0, stub.returnExceptions.size(), 'Invalid number of return exceptions set.');
    }

    private static testMethod void testThatReturn_forAll() {
        stub.currentMethod = 'some not-null value';

        Test.startTest();
        stub.forAllMethods().thatReturns(EXPECTED_RESULT);
        Test.stopTest();

        System.assertEquals(1, stub.returnValues.size(), 'Invalid number of return values set.');
        System.assertEquals(EXPECTED_RESULT, stub.returnValues.get(null), 'Invalid return value set.');
        System.assertEquals(0, stub.returnExceptions.size(), 'Invalid number of return exceptions set.');
    }

    private static testMethod void testThatThrows_forMethod() {
        Test.startTest();
        stub.forMethod(TEST_METHOD_NAME).thatThrows(EXPECTED_EXCEPTION);
        Test.stopTest();

        System.assertEquals(1, stub.returnExceptions.size(), 'Invalid number of return exceptions set.');
        System.assertEquals(EXPECTED_EXCEPTION, stub.returnExceptions.get(TEST_METHOD_NAME), 'Invalid return exception set.');
        System.assertEquals(0, stub.returnValues.size(), 'Invalid number of return values set.');
    }

    private static testMethod void testThatThrows_forAllMethods() {
        stub.currentMethod = 'some not-null value';

        Test.startTest();
        stub.forAllMethods().thatThrows(EXPECTED_EXCEPTION);
        Test.stopTest();

        System.assertEquals(1, stub.returnExceptions.size(), 'Invalid number of return exceptions set.');
        System.assertEquals(EXPECTED_EXCEPTION, stub.returnExceptions.get(null), 'Invalid return exception set.');
        System.assertEquals(0, stub.returnValues.size(), 'Invalid number of return values set.');
    }

    private static testMethod void testStub_withReturnValueForMethod() {
        Test.startTest();
        Object result = stub.forMethod(TEST_METHOD_NAME).thatReturns(EXPECTED_RESULT).handleMethodCall(null, TEST_METHOD_NAME, null, null, null, null);
        Test.stopTest();

        System.assertEquals(EXPECTED_RESULT, result, 'Invalid result returned.');
    }

    private static testMethod void testStub_withReturnValueForAllMethods() {
        Test.startTest();
        Object result = stub.forAllMethods().thatReturns(EXPECTED_RESULT).handleMethodCall(null, TEST_METHOD_NAME, null, null, null, null);
        Test.stopTest();

        System.assertEquals(EXPECTED_RESULT, result, 'Invalid result returned.');
    }

    private static testMethod void testStub_withReturnExceptionForMethod() {
        Exception result;
        Test.startTest();
        try {
            stub.forMethod(TEST_METHOD_NAME).thatThrows(EXPECTED_EXCEPTION).handleMethodCall(null, TEST_METHOD_NAME, null, null, null, null);
            System.assert(false, 'Expected exception not thrown.');
        } catch (Exception ex) {
            result = ex;
        }
        Test.stopTest();

        System.assertEquals(EXPECTED_EXCEPTION, result, 'Invalid exception thrown.');
    }

    private static testMethod void testStub_withReturnExceptionForAllMethods() {
        Exception result;
        Test.startTest();
        try {
            stub.forAllMethods().thatThrows(EXPECTED_EXCEPTION).handleMethodCall(null, TEST_METHOD_NAME, null, null, null, null);
            System.assert(false, 'Expected exception not thrown.');
        } catch (Exception ex) {
            result = ex;
        }
        Test.stopTest();

        System.assertEquals(EXPECTED_EXCEPTION, result, 'Invalid exception thrown.');
    }

    private static testMethod void testStub_withMethodsCalled() {
        final String TEST_METHOD_NAME = 'myMethod';

        Test.startTest();
        stub.handleMethodCall(null, TEST_METHOD_NAME, null, null, null, null);
        Test.stopTest();

        System.assertEquals(1, stub.methodsCalled.size(), 'Invalid number of methods called set.');
        System.assertEquals(TEST_METHOD_NAME, stub.methodsCalled[0], 'Invalid method called set.');
    }
}