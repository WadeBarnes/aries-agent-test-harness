Feature: Aries agent connection functions RFC 0160

   Scenario: establish a connection between two agents
      Given we have two agents "Alice" and "Bob"
      When "Alice" generates a connection invitation
      And "Bob" receives the connection invitation
      And "Bob" sends a connection response
      And "Alice" accepts the connection response
      And "Bob" sends a response ping
      And "Alice" receives the response ping
      Then "Alice" and "Bob" have a connection

   @T001-API10-RFC0160 @P1 @AcceptanceTest @NeedsReview
   Scenario: establish a connection between two agents
      Given we have two agents "Alice" and "Bob"
      When "Alice" generates a connection invitation
      And "Bob" receives the connection invitation
      And "Bob" sends a connection request
      And "Alice" receives the connection request
      And "Alice" sends a connection response
      Then "Alice" and "Bob" have a connection

   @T002-API10-RFC0160 @P1 @AcceptanceTest @NeedsReview
   Scenario Outline: Connection established between two agents and inviter gets a preceding message
      Given we have "2" agents
         | name  | role    |
         | Alice | inviter |
         | Bob   | invitee |
      And "Bob" has sent a connection request to "Alice"
      And "Alice" has accepted the connection request by sending a connection response
      And "Bob" is in the state of complete
      And "Alice" is in the state of responded
      When "Bob" sends <message> to "Alice"
      Then "Alice" is in the state of complete

      Examples:
         | message   |
         | acks      |
         | trustping |


   @T003-API10-RFC0160 @SingleUseInvite @P2 @ExceptionTest @NeedsReview
   Scenario: Inviter Sends invitation for one agent second agent tries after connection
      Given we have "3" agents
         | name    | role              |
         | Alice   | inviter           |
         | Bob     | invitee           |
         | Mallory | inviteinterceptor |
      And "Alice" generated a single-use connection invitation
      And "Bob" received the connection invitation
      And "Bob" sent a connection request
      And "Alice" accepts the connection request by sending a connection response
      And "Alice" and "Bob" have a connection
      When "Mallory" sends a connection request to "Alice" based on the connection invitation
      Then "Alice" sends a request_not_accepted error

   @T004-API10-RFC0160 @SingleUseInvite @P2 @ExceptionTest @NeedsReview
   Scenario: Inviter Sends invitation for one agent second agent tries during first share phase
      Given we have "3" agents
         | name    | role              |
         | Alice   | inviter           |
         | Bob     | invitee           |
         | Mallory | inviteinterceptor |
      And "Alice" generated a single-use connection invitation
      And "Bob" received the connection invitation
      And "Bob" sent a connection request
      When "Mallory" sends a connection request to "Alice" based on the connection invitation
      Then "Alice" sends a request_not_accepted error

   @T005-API10-RFC0160 @MultiUseInvite @P3 @DerivedFunctionalTest @NeedsReview**
   Scenario: Inviter Sends invitation for multiple agents
      Given we have "3" agents
         | name    | role              |
         | Alice   | inviter           |
         | Bob     | invitee           |
         | Mallory | inviteinterceptor |
      And "Alice" generated a multi-use connection invitation
      And "Bob" received the connection invitation
      And "Bob" sent a connection request
      And "Alice" sent a connection response to "Bob"
      When "Mallory" sends a connection request based on the connection invitation
      Then "Alice" sent a connection response to "Mallory"

   @T006-API10-RFC0160 @P4 @DerivedFunctionalTest @NeedsReview
   Scenario: Establish a connection between two agents who already have a connection initiated from invitee
      Given we have "2" agents
         | name  | role    |
         | Alice | inviter |
         | Bob   | invitee |
      And "Alice" and "Bob" have an existing connection
      When "Bob" generates a connection invitation
      And "Bob" and "Alice" complete the connection process
      Then "Alice" and "Bob" have another connection

   Scenario: send a trust ping between two agents
      Given "Alice" and "Bob" have an existing connection
      When "Alice" sends a trust ping
      Then "Bob" receives the trust ping
