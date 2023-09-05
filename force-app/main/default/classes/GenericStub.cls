/**
 * @author David Fernandez
 * @date 15.07.2021
 *
 * @description Stub class to replace ANY service class in unit tests
 */
public with sharing class GenericStub implements StubProvider {

    @TestVisible
    private String currentMethod;
    // return values per method name
    @TestVisible
    private Map<String, Object> returnValues = new Map<String, Object>();
    // return exceptions per method name
    @TestVisible
    private Map<String, Exception> returnExceptions = new Map<String, Exception>();
    @TestVisible
    private List<String> methodsCalled = new List<String>();

    /**
     * @description Sets the particular method (to be used to define the return value or return exception then).
     *
     * @param methodName The name of the method to be set as the current one
     *
     * @return this GenericStub instance
     */
    public GenericStub forMethod(String methodName) {
        this.currentMethod = methodName;
        return this;
    }

    /**
     * @description Resets the current method.
     *
     * @return this GenericStub instance
     */
    public GenericStub forAllMethods() {
        this.currentMethod = null;
        return this;
    }

    /**
     * @description Makes the stub to return the given value (either for the current method, or for all methods).
     *
     * @param returnValue The value to return
     *
     * @return this GenericStub instance
     */
    public GenericStub thatReturns(Object returnValue) {
        if (this.currentMethod != null) {
            this.returnValues.put(this.currentMethod, returnValue);
        } else {
            this.returnValues.put(null, returnValue);
        }
        return this;
    }

    /**
     * @description Makes the stub to throw exception (either for the current method, or for all methods).
     * @param returnException The exception to be thrown
     *
     * @return this GenericStub instance
     */
    public GenericStub thatThrows(Exception returnException) {
        if (this.currentMethod != null) {
            this.returnExceptions.put(this.currentMethod, returnException);
        } else {
            this.returnExceptions.put(null, returnException);
        }
        return this;
    }

    /**
     * @description Implemented method of System.StubProvider. Logs the called method and either throws an exception, or returns a value, as defined.
     * @param stubbedObject an object that is wrapped by mock
     * @param stubbedMethodName the object's method name that was called
     * @param returnType return type of the object's method
     * @param listOfParamTypes list of the object's method's parameters' types
     * @param listOfParamNames list of the object's method's parameters' names
     * @param listOfArgs list of arguments passed to the object's method
     *
     * @return The return value or the return exception for the particular method if method's name is found in list, or the generic value or exception for the whole stubbed class
     */
    public Object handleMethodCall(Object stubbedObject, String stubbedMethodName, System.Type returnType, List<System.Type> listOfParamTypes, List<String> listOfParamNames, List<Object> listOfArgs) {
        methodsCalled.add(stubbedMethodName);

        if (returnExceptions.containsKey(stubbedMethodName)) {
            throw returnExceptions.get(stubbedMethodName);
        } else if (returnValues.containsKey(stubbedMethodName)) {
            return returnValues.get(stubbedMethodName);
        } else if (returnExceptions.containsKey(null)) {
            throw returnExceptions.get(null);
        } else {
            return returnValues.get(null);
        }
    }
}