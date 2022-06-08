@admin
@data_entry
Feature: Admin: games

Scenario: Adding a game
  When an admin adds a game
  Then the game should appear on the admin games list
  And there should be an admin page for that game

Scenario: Editing a game
  Given a game
  When an admin edits the game
  Then the edits to the game should've been saved

Scenario: Deleting a game
  Given a game
  When an admin deletes the game
  Then the game shouldn't appear on the admin games list

@anonymous
Scenario: Anonymous user cannot access this area
  When the user goes to the admin games area
  Then they should be bounced to the admin login page
