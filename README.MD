project5 - Evil Hangman - README

In this project a native hangman app is developed. However, it isn't a regular hangman, but an evil hangman.
The word the app has in mind changes over time in such a way that guessing a correct word becomes virtually impossible.

FEATURES
- The app has three views: a MainView, a SettingsView and a HighscoresView. 
  Mockups have been made (in doc folder, not for Highscores).
- The main view shows the keyboard (always on, not dismissable) and the following info:
    + Current word progress. Non-guessed letters are hyphenated, guessed letters are uppercase.
    + Played letters: all played letters appear as they are played.
    + Remaining guesses: the number of guesses left before game over.
    + Occasional warning message: incorrect symbol or already played letter.
    + A small (i) button to flip over to settings.
    + A New Game button.
    + (Maybe) a (static) hangman picture.
- The settings view shows the following info:
    + Evil Mode: whether to use evil mode or play a fair hangman.
    + Word Length: length of words to guess.
    + Guesses: number of guesses before game over.
    + (Maybe) button to show highscore view.
- Additionally, other (behind the scenes) features are implemented as required by the specification:
    + Backgrounding/force quit save state
    + Saving settings
    + Success/fail message after win/loss
    + Highscore view after win/loss
    
TECHNOLOGIES
- Standard Cocoa Touch frameworks/libraries should suffice for the project:
    + NSDictionary/array for manipulation of the word list
    + NSString for analysis of words
    + ...
