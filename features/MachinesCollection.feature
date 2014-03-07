Feature: Machines collection
    As an anonymous user
    I want to be able to access machine collection
    So that I can create a Machine and retrieve exists Machines

    Background:
        Given API Blueprint in file "test/fixtures/apiary.apib"
        And base url http://localhost:3333

    Scenario: Create a Machine
        When I do action Machines > Machines collection > Create a Machine
        And the request message body is JSON
        """
        {
            "type": "bulldozer",
            "name": "willy"
        }
        """
        Then It should be Accepted (202)
        And the response message body is JSON
        """
        {
            "message": "Accepted"
        }
        """

    Scenario: Retrieve all Machines
        When I do action Machines > Machines collection > Retrieve all Machines
        Then It should be Ok (200)
        And the response message body is JSON
        """
        [{
            "_id": "52341870ed55224b15ff07ef",
            "type": "bulldozer",
            "name": "willy"
        }]
        """
