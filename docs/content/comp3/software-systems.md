#Software Subsystems

Software is an unbrella term for competition 3. There are many sub-teams that are under software to accomplish different software challenges that we have at Waterloop. Having sub-teams divide the workload and allows team members to focus on their role. The software team is made up for mainly following sub-teams:
- Pod Embedded Systems
- Pod Backend/Communication-systems
- Waterloop official Website
- Waterloop Internal Website

## Pod Embedded Systems
Embedded systems play a crucial role for the success of Waterloop at hyperloop competition. This team writes the code that directly runs on the pod. They have to ensure that the code they write is safe and fast because even a delay of a second can cause problems when pod is travelling so fast in the hyperloop tube. Waterloop is using Arduino based embedded systems for their Goose 3 pod. The current specs have not been decided on yet. Below are guidelines and tools we use to program Waterloop embedded systems.

### **C++ Coding Style**

The following styling guidelines should be used when naming all variables and functions when writing C/C++ code for the Waterloop embedded software.

#### **Whitespacing**
- 4 space indentation
- `{`'s go on the same line
- No space between function name and `(`
- Space between function `)` and `{`
- Space between class name and `{`
- Space between `if` and `(`, `)` and `{`

#### **Variable Naming**

All variable names should be clear and meaningful, including temporary variables whose scope is only a function block or a few lines of code.

All variable names should use camel case (e.g. colorSensorState, rpmReading).

First, the following scope prefixes should be used when naming variables, to help identify the scope of the variable.

| Variable Scope  | Prefix | Example      |
|-----------------|--------|--------------|
| Local Variable  | None   | nIndex       |
| Global Variable | g_     | g_nLineCount |
| Member Variable | m_     | m_strName    |

Second, the following type prefixes should be used when naming variables, to help identify the type of the variable.

| Variable Type | Prefix | Example |
|---------------|--------|---------|
| Reference     | r      | rSensor |
| Pointer       | p      | pTimer  |

Third, another type prefix should be used when naming variables, to help further identify the type of the variable.

| Variable Type | Prefix | Example        |
|---------------|--------|----------------|
| Constant      | k      | kMaxValue      |
| Static        | s      | sObjectCounter |


Exception: all static const values should be all caps and use underscores to separate words. For example
`static const int TIMER_INTERVAL_MS = 350;`

#### **Function Naming**

All function names should be clear and meaningful.

All function names should use camel case (e.g. InitializeColorSensor(), resetTimers(), addTfsaAccount()).

The following functions should have names that start with a capital letter:
1. Global functions (static or not)
2. Public member functions (static or not)

The following functions should have names that start with a small letter:
1. Protected member functions
2. Private member functions

#### **Class Member Ordering**

Whenever you are creating a new class, whether the header file or the implementation file, all members should follow this order:
1. Public static const values
2. Public static functions
3. Public functions
4. There should be no public static values that are not const.
5. There should be no public values that are directly accessible. Always use getter and setter functions.
6. Protected static functions
7. Protected functions
8. Private static functions
9. Private functions
10. Protected values
11. Private values

If a member is not mentioned in above list, use your best judgement of where it fits the best based on the patterns you see. Briefly, the rules are:
1. Access is ordered as public, protected, then private.
2. Static members come before non-static member.
3. Functions come before values.

#### **Full Example**

The following code was taken for the well-style SensorReader class in the control repository:

SensorReader.h:

```cpp
#ifndef CONTROL_SENSORREADER_H
#define CONTROL_SENSORREADER_H

// Header files created by us that are part of the project
// should use quotes instead of <> (used for pre-existing
// system headers).
#include "sensors/mag/Rpm.h"

class State;

class SensorReader {

public:
    SensorReader(State &rState);
	
    ~SensorReader();
		
    void Read(); // public functions should be capitalized

private: // Access keywords should always be declared regardless of default

    State &m_rState; // m_ indicates a member variable, r indicates this is a reference

    Rpm *m_pFlmRpm; // p indicates this is a pointer
    Rpm *m_pFrmRpm;
    Rpm *m_pRlmRpm;
    Rpm *m_pRrmRpm;

};

#endif //CONTROL_SENSORREADER_H
```
SensorReader.cc:
```cpp
#include <Arduino.h>
#include <JsonHandler.h>
#include <Watchdog/State.h>
#include "SensorReader.h"
#include "Config.h"

// Global variables are not recommended unless absolutely recommended.
// Avoiding global variables will reduce name conflicts in the future.
// This can be moved to the Read function and made static, or simply
// made another member variable.
long g_lLastTime = millis(); // g_ means global, l means long

SensorReader::SensorReader(State &rState) :
    m_rState(rState), // Long initialization lists are easier to read this way
    m_pFlmRpm(nullptr),
    m_pFrmRpm(nullptr),
    m_pRlmRpm(nullptr),
    m_pRrmRpm(nullptr) {
        // A value of 260 is over the max of uint8_t (that is 255).
        // Fix warning by using the max defined by UINT8_MAX.
        m_pFlmRpm = new Rpm("rpmflm", UINT8_MAX, config.flmSensor); // No good reason for list initialization
        m_pFrmRpm = new Rpm("rpmfrm", UINT8_MAX, config.frmSensor);
}

void SensorReader::Read() {
    m_rState.currRpmFL = m_pFlmRpm->read();

    if (millis() - glLastTime >= 200) {
        //wlp::serial << *m_pFlmRpm;

        // glLastTime = millis(); // Doesn't glLastTime need to be updated here?
    }
}

SensorReader::~SensorReader() {
    delete m_pFlmRpm;
    delete m_pFrmRpm;
    delete m_pRlmRpm;
    delete m_pRrmRpm;
}
```

### **PlatformIO Overview**
Waterloo code base will be compiled and uploaded to Arduino using [PlatformIO](http://platformio.org/). This ecosystem makes it convenient to run and manage complex and large scale projects. It uses makefiles and board dependencies, that it manages on it own, to make sure the code gets compiled successfully. Few benefits of PlatformIO:
* Freedom to use any editor and many [supported IDEs](http://docs.platformio.org/en/latest/ide.html#ide).
* Organizes the code in **src**, **bin** and optionally **examples** folder to give project a good structure.
* Use almost any OS and carry on from where you left.

#### **Installing PlatformIO Core**

[PlatformIO Core](http://docs.platformio.org/en/latest/core.html) is the core software files that make PlatformIO function. Regardless of what text editor or IDE you use, you have to install these core libraries. To install them follow the following steps:
* Windows
  * PlatformIO requires Python 2.7 so if it is not downloaded, download it from [Python website](https://www.python.org/downloads/)
  * Download [getPlatformIO.py](https://raw.githubusercontent.com/platformio/platformio/develop/scripts/get-platformio.py) script
  * change directory to folder where is located downloaded "get-platformio.py": ``cd C:\path\to\dir\where\is\located\get-platformio.py\script`` 
  * run the script: ``C:\Python27\python.exe get-platformio.py``
* Mac
  * The latest stable version of PlatformIO may be installed or upgraded via macOS Homebrew Packages Manager (brew): ``brew install platformio``
* Linux
  * The latest stable version of PlatformIO may be installed or upgraded via Python Package Manager (pip): ``pip install -U platformio``

For more information on how to download PlatformIO check their [installation](http://docs.platformio.org/en/latest/installation.html") page.

#### **Creating PlatformIO Projects**

Now that installation of core libraries is done you are ready to create and modify PlatformIO projects. Following are steps you have to follow if you want to create a PlatformIO project:

* CLion IDE
  * Follow the instructions on [PlatformIO CLion installation](http://docs.platformio.org/en/latest/ide/clion.html) page to setup CLion
  * Create a platformIO project using: ``platformio init --ide clion --board <ID>``. The IDs we will use are:
      * uno-> Uno boards: ``platformio init --ide clion --board uno``
      * megaatmega2560 -> Mega boards: ``platformio init --ide clion --board megaatmega2560``
  * Place source files (*.c, *.cpp, *.h, *.hpp) to src directory and repeat ``platformio init --ide`` command above (to refresh source files list)
  * Import this project via **Menu: File > Import Project** and specify root directory where is located Project [Configuration File platformio.ini](http://docs.platformio.org/en/latest/projectconf.html#projectconf)
  * Build project (DO NOT use “Run”) **Menu: Run > Build**

* Text Editor

* Atom/VS Code
  * Follow the instructions on [PlatformIO IDE installation](http://docs.platformio.org/en/latest/ide/pioide.html) page to setup Atom or VS Code
  * Read [PlatformIO IDE get started](http://docs.platformio.org/en/latest/ide/atom.html#quick-start) page to learn about how to create and manage projects
* Other IDE
  * Follow the instructions on [PlatformIO Other IDEs installation](http://docs.platformio.org/en/latest/ide.html#other-ide)

#### **Commandline PlatformIO**

| Command		                                                                       | Use case    |
|--------------------------------------------------------------------------------------|-------------|
| [platformio init](http://docs.platformio.org/en/latest/userguide/cmd_init.html#)     |create/update|
| [platformio run](http://docs.platformio.org/en/latest/userguide/cmd_run.html)        |run/build    |

#### **Working with Waterloop projects**

Since the code base for Waterloop embedded systems is written in PlatformIO, you will not have to create anything but rather use the code and initialize on your machine. **Wlib** library will follow the same instructions. Following are the steps to do so:

* Clone the repo on your machine and go the folder
* If using CLion:
    1) Initialize the repo: ``platformio init --ide clion --board <ID>``
    2) Every time you import a library or add a new file you have to re-index the project. This is done by choosing the re-indexing from the build options in CLion. Check this [screenshot](http://docs.platformio.org/en/latest/_images/ide-platformio-clion.png) for the build options
    3) If the option 2 does not seem to work, you can always Initialize the project with option 1
* If using Atom/VS Code:
    1) You can import the project and work with it. See this [link](http://docs.platformio.org/en/latest/ide/vscode.html#setting-up-the-project) for information on how to do that

These are all the information you need to get started with PlatformIO. For information in detail check [PlatformIO docs](http://docs.platformio.org/en/latest/)

### **Guidelines for working with Waterloop Repositories**
We will be using a lot of open source libraries in our projects. If you find an open source library that you want to include, place it in **lib** folder. Follow the following steps to include a library:

* Make sure library is Arduino compatible. C++ library != Arduino library. If you still really like the C++ library modify it to make it Arduinio compatible.
* Git library:
    * Clone the library as a Submodule ``git submodule add <library address>``
* Other library:
    * Copy and paste the library in **lib** folder. Make sure the library has **src** folder and all the source files are in that. 
 
When cloning Waterloop Repositories including **Wlib** library, follow the guidelines below:
* After cloning the library, run ``git submodule init`` and ``git submodule update`` immediately after to initialize dependencies that are included as submodules.

When making changes to the code and pushing changes, follow the following guidelines:
* You must never push text editor or IDE specific files to the repo. Always ``gitignore`` such files.
* Never make a commit and push straight to the repo. Always make a pull request so that your team members can review the code. This means always commit your code by making a new branch and never working straight in ``master``.
* If there is a new feature you are implementing, implement it in a new branch so that ``master`` branch can stay stable.
* Follow the [C Plus Plus coding style](https://github.com/teamwaterloop/wlib/wiki/C-plus-plus-Coding-Style) file in this wiki. **This is must and everyone must oblige to keep code base consistent**.
* Document the code as described in [Documentation Standard](https://github.com/teamwaterloop/wlib/wiki/Documentation-Standard) file in this wiki. **This is again must and everyone must oblige to keep the code well documented**.
* If writing a library like we are doing for **Wlib** create a folder for your feature in **examples** folder and create a **.ino** file that uses your feature. Make this file as detailed so that the person using this library can see how to use your feature. The **.ino** file will be an arduino file so follow the Arduino project guidelines.

### Documentation
Documentation is very important for a project and hence Waterloop must comply with certain documentation standards to make the code base consistent and well documented. Since we will be writing the embedded code in C/C++ we will be using [doxygen](http://www.stack.nl/~dimitri/doxygen/) style documentation for our projects. This is very similar to [Java Docs](https://en.wikipedia.org/wiki/Javadoc) and hence people familiar wit Java Docs can easily get used to it. This page will list all the rules our team will follow.

#### Starting of each file
Each file needs to begin with the **@file** command stating the name of the file. This should be followed by a brief description of the file using the **@brief** command. If necessary, you can follow this with a more detailed description. Next you should put your name along with any other person who worked on it using the **@author** tag. This needs to be followed with a bugs section with a list of known bugs using the **@bug** command. If there are no known bugs, explicitly state that using the **@bug** command. Also include a date for the last modification by using **@date** tag. This has to be followed in both .h files and .cpp/.c files. Examples:

```cpp
/** @file console.h
 *  @brief Function prototypes for the console driver.
 *
 *  This contains the prototypes for the console
 *  driver and eventually any macros, constants,
 *  or global variables you will need.
 *
 *  @author Harry Q. Bovik (hqbovik)
 *  @author Fred Hacker (fhacker)
 *  @date October 16, 2017
 *  @bug No known bugs.
 */
```

```cpp
/** @file console.c
 *  @brief A console driver.
 *
 *  These empty function definitions are provided
 *  so that stdio will build without complaining.
 *  You will need to fill these functions in. This
 *  is the implementation of the console driver.
 *  Important details about its implementation
 *  should go in these comments.
 *
 *  @author Harry Q. Bovik (hqbovik)
 *  @author Fred Hacker (fhacker)
 *  @date October 16, 2017
 *  @bug No know bugs.
 */
```

#### Document methods/functions
Before each function, data structure, and macro you should put a comment block giving at least a brief description using the **@brief** command. A brief description will suffice for your data structures but for you macros and functions you will need to use a few more commands. After your description, you should use the **@param** command to describe all of the parameters to your function. These descriptions should be followed by a description of the return value using the **@return** command. Note: When we say "each" function, that is not a strong statement. You can leave out simple helper functions, like a ``max()`` macro, so you don't waste time. Documentation for each method/function must only be placed in the header **.h** files and not in **.cpp/.c** files. Examples:

```cpp
/**
 * @brief Example showing how to document a function with Doxygen.
 *
 * Description of what the function does. If you want to refer to parameters in
 * description you can use @p param1 or @p param2. A word from code can also be
 * inserted like @c int. This can be useful to say that function returns a @c void
 * or @c int. This basically writes the words in typewriter font.
 * Sometimes it is also convenient to include an example of usage:
 * @code
 * ClassObject *object = new ClassObject(param1, param2);
 * hello("something...\n");
 * @endcode
 * @param param1 Description of the first parameter of the function.
 * @param param2 The second one, which follows @p param1.
 * @return Describe what the function returns.
 * @see specify a link or a name of function in the class
 * @see http://website/
 * @note Something to note
 * @warning some warning
 */
int example(int param1, int param2);
```

The example above shows all the things you can do. You do not have to use all of them except the couple of mandatory ones as explained above. Examples below show more general use cases:

```cpp
/** @brief Prints character ch at the current location
 *         of the cursor.
 *
 *  If the character is a newline ('\n'), the cursor should
 *  be moved to the next line (scrolling if necessary).  If
 *  the character is a carriage return ('\r'), the cursor
 *  should be immediately reset to the beginning of the current
 *  line, causing any future output to overwrite any existing
 *  output on the line.  If backsapce ('\b') is encountered,
 *  the previous character should be erased (write a space
 *  over it and move the cursor back one column).  It is up
 *  to you how you want to handle a backspace occurring at the
 *  beginning of a line.
 *
 *  @param ch the character to print
 *  @return The input character
 */
int putbyte( char ch );
```

```cpp
/** @brief Prints the string s, starting at the current
 *         location of the cursor.
 *
 *  If the string is longer than the current line, the
 *  string should fill up the current line and then
 *  continue on the next line. If the string exceeds
 *  available space on the entire console, the screen
 *  should scroll up one line, and then the string should
 *  continue on the new line.  If '\n', '\r', and '\b' are
 *  encountered within the string, they should be handled
 *  as per putbyte. If len is not a positive integer or s
 *  is null, the function has no effect.
 *
 *  @param s The string to be printed.
 *  @param len The length of the string s.
 *  @return Void.
 */
void putbytes(const char* s, int len);
```

#### Document Classes
Classes are documented in a similar fashion to methods but they do not need **@param** and **@return** statements. Class only needs **@brief** for brief info about the class and then more documentation if longer information is needed to be conveyed. For template arguments use **@tparam**. Examples:

```cpp
/** 
 *  @brief metafunction for generation of a map of message types to
 *  their associated callbacks.
 *  @tparam Seq the list of message types
*/
template<class Seq>
class generate_callback_map
{
    typedef typename mpl::transform< Seq, build_type_signature_pair< mpl::_1 >>::type vector_pair_type;
    typedef typename fusion::result_of::as_map< vector_pair_type >::type type;
};
```

#### Document Enum

Enum will be documented by having a **@brief** tag on top of it to briefly explain what is the purpose of this Enum and then more detailed information can be provided after that. It is usually a good idea to document individual options inside the enum using inline comments. They are typed like this: ``/**<SOME_COMMENT */``. Example:

```cpp
/**
 * @brief Use brief, otherwise the index won't have a brief explanation.
 *
 * Detailed explanation.
 */
enum Switch {
  ON,  /**< Some documentation for On switch. */
  OFF, /**< Some documentation for Off switch. */
};
```

#### Other Useful tags
* **@todo** can be used to mention anything that is left to be done

#### Full Example
The code examples below do not necessarily follow our coding standards but they are there for documentation examples. So follow them only for our documentation standards

```h
/** @file console.h
 *  @brief Function prototypes for the console driver.
 *
 *  This contains the prototypes for the console
 *  driver and eventually any macros, constants,
 *  or global variables you will need.
 *
 *  @author Harry Q. Bovik (hqbovik)
 *  @author Fred Hacker (fhacker)
 *  @date October 16, 2017
 *  @bug No known bugs.
 */

#ifndef _MY_CONSOLE_H
#define _MY_CONSOLE_H

#include <video_defines.h>

/** @brief Prints character ch at the current location
 *         of the cursor.
 *
 *  If the character is a newline ('\n'), the cursor should
 *  be moved to the next line (scrolling if necessary).  If
 *  the character is a carriage return ('\r'), the cursor
 *  should be immediately reset to the beginning of the current
 *  line, causing any future output to overwrite any existing
 *  output on the line.  If backsapce ('\b') is encountered,
 *  the previous character should be erased (write a space
 *  over it and move the cursor back one column).  It is up
 *  to you how you want to handle a backspace occurring at the
 *  beginning of a line.
 *
 *  @param ch the character to print
 *  @return The input character
 */
int putbyte( char ch );

/** @brief Prints the string s, starting at the current
 *         location of the cursor.
 *
 *  If the string is longer than the current line, the
 *  string should fill up the current line and then
 *  continue on the next line. If the string exceeds
 *  available space on the entire console, the screen
 *  should scroll up one line, and then the string should
 *  continue on the new line.  If '\n', '\r', and '\b' are
 *  encountered within the string, they should be handled
 *  as per putbyte. If len is not a positive integer or s
 *  is null, the function has no effect.
 *
 *  @param s The string to be printed.
 *  @param len The length of the string s.
 */
void putbytes(const char* s, int len);

/** @brief Changes the foreground and background color
 *         of future characters printed on the console.
 *
 *  If the color code is invalid, the function has no effect.
 *
 *  @param color The new color code.
 */
void set_term_color(int color);

/** @brief Writes the current foreground and background
 *         color of characters printed on the console
 *         into the argument color.
 *  @param color The address to which the current color
 *         information will be written.
 */
void get_term_color(int* color);

/** @brief Sets the position of the cursor to the
 *         position (row, col).
 *
 *  Subsequent calls to putbytes should cause the console
 *  output to begin at the new position. If the cursor is
 *  currently hidden, a call to set_cursor() must not show
 *  the cursor.
 *
 *  @param row The new row for the cursor.
 *  @param col The new column for the cursor.
 */
void set_cursor(int row, int col);

/** @brief Writes the current position of the cursor
 *         into the arguments row and col.
 *  @param row The address to which the current cursor
 *         row will be written.
 *  @param col The address to which the current cursor
 *         column will be written.
 */
void get_cursor(int* row, int* col);

/** @brief Hides the cursor.
 *
 *  Subsequent calls to putbytes must not cause the
 *  cursor to show again.
 */
void hide_cursor();

/** @brief Shows the cursor.
 *  
 *  If the cursor is already shown, the function has no effect.
 */
void show_cursor();

/** @brief Clears the entire console.
 */
void clear_console();

/** @brief Prints character ch with the specified color
 *         at position (row, col).
 *
 *  If any argument is invalid, the function has no effect.
 *
 *  @param row The row in which to display the character.
 *  @param col The column in which to display the character.
 *  @param ch The character to display.
 *  @param color The color to use to display the character.
 */
void draw_char(int row, int col, int ch, int color);

/** @brief Returns the character displayed at position (row, col).
 *  @param row Row of the character.
 *  @param col Column of the character.
 *  @return The character at (row, col).
 */
char get_char(int row, int col);

#endif /* _MY_CONSOLE_H */
```

```cpp
/** @file console.c
 *  @brief A console driver.
 *
 *  These empty function definitions are provided
 *  so that stdio will build without complaining.
 *  You will need to fill these functions in. This
 *  is the implementation of the console driver.
 *  Important details about its implementation
 *  should go in these comments.
 *
 *  @author Harry Q. Bovik (hqbovik)
 *  @author Fred Hacker (fhacker)
 *  @date October 16, 2017
 *  @bug No know bugs.
 */

#include <console.h>

int putbyte( char ch ){
  return ch;
}

void  putbytes( const char *s, int len ){
}

void set_term_color( int color ){
}

void get_term_color( int *color ){
}

void set_cursor( int row, int col ){
}

void get_cursor( int *row, int *col ){
}

void hide_cursor(){
}

void show_cursor(){
}

void clear_console(){
}

void draw_char( int row, int col, int ch, int color ){
}
```
