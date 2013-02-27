microtome
=========

An ORM tool for parsing and managing game data in your favorite game development language.

## What

microtome consists of two components: a code generator, and a runtime. 

The code generator reads simple descriptor files that describe your game data structure. It generates class files in your game development language of choice.

You include the runtime in your game. It reads game data stored in XML and produces instances of the generated classes.

## Quickstart

* Ensure python 2.7 is installed
* Install pystache: ```$ sudo pip install pystache``` or ```$ sudo easy_install pystache```
* Generate test microtome "pages": ```$ /path/to/microtome/bin/gen-test-pages```
* Run the test applications at  ```microtome/runtime/src/test/as``` (ActionScript) and ```microtome/runtime/src/main/objc``` (Objective-C).

## Language support

microtome supports ActionScript and Objective-C, but it's designed to be extensible to other languages. To support a new language, you'll need to write a code generator (look at ```microtome/genpages/generator_as.py``` and ```microtome/genpages/generator_objc.py``` for examples) and a runtime (look at ```microtome/runtime/src/main/as``` and ```microtome/runtime/src/main/objc```).

Both runtimes currently support XML, but other data formats (such as JSON) are easily supported as well.
    
## Example

```
namespace com.dungeoncrawler;

GameData {
  HeroPage hero;
  Tome<BaddiePage> baddies;
}

HeroPage extends ActorPage {
    float mana (min=0);
    float manaRegenRate (min=0);
}

BaddiePage extends ActorPage {
    int xpValue;
}

ActorPage {
    float health (min=0);
    float walkSpeed (min=0);
    AttackPage attack;
}

AttackPage {
    int damage;
    float range (min=0);
}

```
    
