Feature: Text nodes
  As an editor
  I want to manage page contents
  So people have something to read

  Scenario: Viewing an existing text node
    Given a root node
    Given a text node with name "sektionen" and content "Enterprise-renholm"

    When I visit "/sektionen"

    Then I should see "Enterprise-renholm"

  Scenario: Creating a new node
    Given a root node

    When I create a new text node with content "Haxxor" and name "sektionen"
    And I visit "/sektionen"

    Then I should see "Haxxor"

  Scenario: Renaming a node
    Given a root node
    And a text node with name "sektionen" and content "En deployanvändare vore nåt"

    When I change the name of node with url "/sektionen" to "ior"
    And I visit "/ior"

    Then I should see "En deployanvändare vore nåt"

  Scenario: Removing a node
    Given a root node
    And a text node with name "sektionen" and content "Redundanta konfigurationsfiler, styrka"

    When I visit "/sektionen"
    When I press the delete button on the node with url "/sektionen"

    Then I should get a 404 response when I visit "/sektionen"

  Scenario: Creating a node with liquid
    Given a root node
    And a text node with name "included" and content "små barn"

    When I create a new text node with content "{% include '/included' %}" and name "barn"
    And I visit "/barn"

    Then I should see "små barn"

  Scenario: Creating a text node with custom layout
    Given a root node

    When I create a new text node with name "test" and content "content" and custom layout "test"
    And I visit "/test"

    Then I should see "testlayout"

