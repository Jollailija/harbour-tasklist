About this fork/branch
================
This branch is "maintained" by jollailija (contact: jollailija [at] gmail.com)  
I have removed the DropBox support completely. However, all other functions (except translations, I'll fix them soon (TM)) including exporting and importing locally should work.

Who is this for?  
Well, those who don't like cloud services or just want to build the app without the API key.  

TaskList
================
A small but mighty program to manage your daily tasks.

Developing
================
Have a look here to prepare your build environment for TaskList: https://github.com/Armadill0/harbour-tasklist/wiki  

NOTE:  
You don't need the private key to build this branch, since the DropBox support has been removed.

Contact
================
Email: tasklist [at] penguinfriends [dot] org

IRC: #sailfishos - Freenode

Features
================
- multiple task lists
    - set default list which is displayed on application start
    - set the list which is displayed in the cover
    - move tasks between lists (user requested feature)
    - lock/unlock orientation on demand (user requested feature)
- add multiple tasks from the clipboard, devided by new lines (user requested feature)
    - to avoid invalid massive task additions this is done via a remorse action
- keyboard support (e.g. TOHKBD 2 by dirkvl, kimmoli and wazd)
    - Tab switchs to TextFields on Task, List and Tag page
    - Cursor left/right switchs lists on Task page
- export and import all your data to a single JSON file
    - synchronize all your data with a Dropbox account
- cover shows current, it's own or the default task list
    - cover action to add task to list shown in cover
    - cover action to switch between lists (user requested feature)
- task can be marked as done
    - function to delete all done tasks
    - marking of done/open tasks can be inverted (user requested feature)
- tags can be added to a task
- several smart lists help you to keep an eye on tasks with simliar meta information
    - e.g. open tasks, done tasks, new tasks, ...
- due dates for each tasks can be specified
    - reminders in the calendar is currently lacking due to missing SailfishOS calendar API
- orientation can be temporary locked (user requested feature)
- remorse items for all necessary actions (e.x. delete tasks/lists)
    - configurable remorse item times
- multiple languages supported (depending on system language), for more information see below
- app can be started to background, in list view or to default list by setting
- copy list to clipboard for usage in other applications

Internationalization
================
- current languages: English (default), German, Spanish, Russian, French, Turkish, Czech, Finnish, Swedish, Dutch, Catalan, Italian, Chinese (Mainland), Danish, Lithuanian, Kurdish, Hungarian, Polish
- translations are managed via Transifex: https://www.transifex.com/projects/p/tasklist/
    - Feel free to request new languages or complete existing ones there. :-)
    - Every contributor will be mentioned in the About page!

Contributors
================
- Manuel Soriano
- Ilja Balonov
- L&eacute;onard Meyer
- Anatoly Shipitsin
- fri
- Jiri Gr&ouml;nroos
- &#304;smail Adnan Sar&#305;er
- &Aring;ke Engelbrektson
- Heimen Stoffels
- Agust&iacute; Clara
- lorenzo facca
- TylerTemp
- Peter Jespersen
- Moo
- Murat Khairulin

Known Issues
================
see here: https://github.com/Armadill0/harbour-tasklist/issues?q=is%3Aopen+is%3Aissue+label%3Abug
