# Cucumber 4 API Blueprint

[![Build Status](https://travis-ci.org/stekycz/cucumber-4-api-blueprint.png?branch=master)](https://travis-ci.org/stekycz/cucumber-4-api-blueprint)

- [Description](#description)
- [Author](#author)

## Description

Inspired by [balanced-api](https://github.com/balanced/balanced-api) an updated for usage with API Blueprint.

Currently you have to use parameter `-r` for [cucumber](https://www.npmjs.org/package/cucumber) to specify usage of step definitions. There will be auto loading in the future version.

### Feature examples
```gherkin
Feature: User login

  Background:
    Given API Blueprint in file "../api-definition.apib" # Base URL is taken from HOST in the file

  Scenario: Login as exists user
    When I do action Users > User > Login user
    And parameter username is "gist-user"
    And parameter password is "super-secret-password"
    Then It should be OK (200)
    And the response message body is JSON valid according to the schema
    When I do action Users > User > Read user tokens
    And parameter user_id is 1
    Then It should be OK (200)
    And the response message body is JSON valid according to the schema
    And the response size of "data" is 1
    And the response value of "data[0].expiration" is "2014-02-20 18:54:27"
```

```gherkin
Feature: Gist creation

  Background:
    Given API Blueprint in file "../api-definition.apib"
    And base url http://localhost:8080

  Scenario: Correct creation
    Given I have valid access token
    When I do action Gist > Gist collection > Create new Gist
    And parameter description is "Description of Gist"
    And parameter content is:
    """
    String content
    """
    Then It should be Created (201)
    And the response message body is application/json valid according to the schema
    When I do action Gist > Gist collection > Read all Gists
    And parameter id is 1
    Then It should be OK (200)
    And the response message body is application/json valid according to the schema
    And the response size of "data" is 1

  Scenario: Missing parameter content
    Given I have valid access token
    When I do action Gist > Gist collection > Create new Gist with the application/json body:
    """
    {
        description: "Description of Gist"
    }
    """
    Then It should be Bad Request (400)
    And the response message body is application/json valid according to the schema
    And the response message body is:
    """
    {
        status: "error",
        message: "Missing parameter content"
    }
    """

  Scenario: Missing parameter description
    Given I have valid access token
    When I do action Gist > Gist collection > Create new Gist with the JSON body:
    """
    {
        content: "String content"
    }
    """
    Then It should be Bad Request (400)
    And the response message body is JSON valid according to the schema
    And the response value of "status" is "error"
    And the response value of "message" is "Missing parameter description"
```

### Notes for implementation

- extension of basic [cucumber](https://www.npmjs.org/package/cucumber) (run in root folder using `cucumber.js` command)
- blueprint AST contains default values of parameters, headers and bodies which can be rewritten by parameters from [cucumber](https://www.npmjs.org/package/cucumber) scenario
- all step definitions must be able to handle basic HTTP language for scenario specification
- some step definitions should use resource abstraction instead of HTTP language (preferred way)
- the output will be output by [cucumber](https://www.npmjs.org/package/cucumber) enhanced for specific error cases (eg. comparison of headers, bodies or schema validation)

## Author

My name is Martin Štekl. Feel free to contact me on [e-mail](mailto:martin.stekl@gmail.com)
or follow me on [Twitter](https://twitter.com/stekycz).
