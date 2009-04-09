Feature: In-progress formatter
  In order to maximise complete feature coverage
  As a developer
  I want to know about scenarios that are passing but are tagged as in-progress

  Scenario: passing scenario tagged as in-progress
    When I run cucumber --require ../../formatters/ --require features/step_definitions/ -n --format Cucumber::Formatter::InProgress --tags @in-progress features/sample.feature:8
    Then it should pass with
    """
    .
    
    (::) Scenarios passing which should be failing or pending (::)
    
    features/sample.feature:8:in `Scenario: pass'
    
    1 scenario
    1 passed step
    
    """
  
  Scenario: failing scenario tagged as in-progress
    When I run cucumber --require ../../formatters/ --require features/step_definitions/ -n --format Cucumber::Formatter::InProgress --tags @in-progress features/sample.feature:4

    Then it should fail with
    """
    F

    1 scenario
    1 failed step

    """
      
  Scenario: pending scenario tagged as in-progress
    When I run cucumber --require ../../formatters/ --require features/step_definitions/ -n --format Cucumber::Formatter::InProgress --tags @in-progress features/sample.feature:12

    Then it should pass with
    """
    P

    1 scenario
    1 pending step

    """
      
  Scenario: running no scenarios
    When I run cucumber --require ../../formatters/ --require features/step_definitions/ -n --format Cucumber::Formatter::InProgress

    Then it should fail with
    """
    
    
    0 scenarios
 
    """

