microtome
=========

An ORM-like tool for parsing and managing game data in your favorite game development language.

## What

microtome consists of two components: a code generator, and a runtime.

The code generator reads simple descriptor files that describe your game's data structures. It generates class files in your game development language of choice.

You include the runtime in your game. It reads game data stored in XML and produces instances of the generated classes.

## Quickstart

* Ensure python 2.7 is installed
* `$ cd /path/to/microtome`
* `$ python setup.py install` (or `$ sudo python setup.py install`)
* Generate test microtome "tomes": `$ /path/to/microtome/bin/gen-test-tomes`
* Run the test applications at  `microtome/runtime/src/test/as` (ActionScript) and `microtome/runtime/src/main/objc` (Objective-C).

## Language support

microtome supports ActionScript, Python, and Objective-C out of the box, and is easily extensible to other languages. To support a new language, you'll need to write a code generator (look at ```microtome/gentomes/generator_as.py``` and ```microtome/gentomes/generator_objc.py``` for examples) and a runtime (look at ```microtome/runtime/src/main/as``` and ```microtome/runtime/src/main/objc```).

All runtimes currently support XML, but other data formats (such as JSON) are easily supported as well.

## Example

```
namespace com.dungeoncrawler;

Tome GameData {
  HeroTome hero;
  Tome baddies;
}

Tome HeroTome extends ActorTome {
    float mana (min=0);
    float manaRegenRate (min=0);
}

Tome BaddieTome extends ActorTome {
    int xpValue;
}

Tome ActorTome {
    float health (min=0);
    float walkSpeed (min=0);
    AttackTome attack;
}

Tome AttackTome {
    int damage;
    float range (min=0);
}

```

