Microtome
=========

Microtome is a platform-agnostic tool for saving and loading game data. In some ways, it's similar to tools like [Protobuf](https://github.com/google/protobuf), but it has some different goals.

- Microtome values **human readability and writeability**. A Microtome data file is a very readable XML (or JSON) file. You don't need a custom editor to manage your game's data files - but you can easily graduate to one if and when neccessary.
- Microtome supports **pointers** natively. The basic building block of Microtome data is the "Tome", which is a structure that is uniquely addressable in the library in which it lives. For example, if we have a Skeleton monster in our library: `<battle><monsters><Skeleton tomeType="MonsterTome" hitPoints="10"/></monsters></battle>`, other tomes can refer to it with its unique name: `battle.monsters.Skeleton`. (These pointers are validated and reified on load: if a tome refers to another tome that doesn't exist, the loader will throw an error letting you know.)
- Microtome supports **inheritance**: a Tome type can extend a parent Tome type, so our MonsterTome, above, could extend an "ActorTome" that declares properties that all Actors and Actor subclasses must define.
- Microtome supports custom primitive types (for example, Enums, or a Color type that's specified with a "#aarrggbb" syntax).
- Microtome strongly favors **static** over **dynamic**, and uses code generation to create concrete classes that play well with code introspection and autocomplete. It also **validates all data on load**, and throws errors if loaded data is incomplete or malformed.
- Microtome is **platform agnostic**. It was originally designed for games written in multiple languages (e.g. client-server games). I was sick of using different data serialization tools when switching platforms and languages, and wanted a tool that I could take with me, regardless of platform.
- Microtome is **not** (currently) designed as a super-optimized over-the-wire format. (You could send a serialized Microtome library over the network as XML, but there are better ways to send bytes through a network -- like Protobuf!)

Microtome is optimized for the creation of **immutable game data** - all the game parameters and entity types and other data that's often loaded when a game or level starts.

## Platform support

Microtome consists of two components: a code generator (`gentomes`), and a runtime.

`gentomes` is a Python tool that reads simple descriptor files that describe your game's data structures. It generates class files in your game development language of choice.

The runtime is what you include in your game. It deserializes and serializes Microtome files using the classes you generated with `gentomes`.

Microtome currently has runtime support for Python, ActionScript, and Java, because these are the languages my current game is written in. (There's also an out-of-date Objective-C runtime.)

Extending Microtome's platform support means adding a new language target to `gentomes`, and porting the small, simple runtime. A C# runtime for Unity games, for example, would be simple to implement, and I'll probably do this as I start my next game.

## Example

(This is a sample from my game [Antihero](http://antihero-game.com), which uses Microtome for all its custom data.)

* Create your game's data structures in a simple data description language:

```
namespace aciv.game.desc;

Tome ScenarioDesc {
    string introBaseName (nullable); // multiplayer scenario info
    string scenarioInfoPopupName (nullable); // campaign scenario info

    string debugDescription (nullable);
    BoardDesc board;
    TomeRef<TilesetDesc> tileset;
    TomeRef<ShopDesc> upgradeShop;
    TomeRef<ShopDesc> hirelingShop;
    TomeRef<PlaylistDesc> playlist (default="musicPlaylists.main");

    ScenarioType scenarioType;
    TomeRef<Tome> scenarioParams (nullable); // scenario-specific configuration
    bool mustDeliverBribes (default=false);

    PlayerConfigDesc p1Config;
    PlayerConfigDesc p2Config;

    // TODO: super-hacky! remove me.
    // (use special level-specific buildings that have different burglary properties)
    TomeRef<BurglaryDesc> customLargeBurglary (nullable);

    TomeRef<aciv.game.ai.desc.AIBehaviorDesc> aiBehavior (default="ai_default");
    TomeRef<BaddieSpawnerListDesc> baddieSpawner (default="battle.baddieSpawner_default");
    TomeRef<SkullQuestsDesc> skullQuests (default="battle.skullQuests_default");
    TomeRef<aciv.game.trigger.desc.TriggerListDesc> triggers (nullable);
}

```

* Run the `gentomes` tool to turn these Tome descriptors into class files
* Create one or more XML files containing your data:
```
<microtome>
  <battle tomeType="BattleDesc"
    player2AdditionalSupplies="1"
    pushNotificationSound="notification_turn.caf"
    hero="battle.actors.hero"
    urchin="battle.actors.urchin"
    thug="battle.actors.thug"
    saboteur="battle.actors.saboteur"
    assassin="battle.actors.assassin"
    truant="battle.actors.truant"
    gang="battle.actors.gang"
    ship="battle.actors.ship"
    henchman="battle.actors.baddie1"
    silhouetteAvatar="avatars.silhouetteAvatar"
    maskDistrict="battle.districts.district_mask"
    guildDistrict="battle.districts.district_guild"
    nullDistrict="battle.districts.district_null">

    <syncMultiplayer tomeType="SyncMultiplayerDesc"
      turnTimerBaseTime="80"
      turnTimerTimePerAction="10"
      turnTimerWarning="30"
      turnTimerDisplayOffset="-3">
    </syncMultiplayer>

    <traps tomeType="TrapsDesc" numTurns="2">
      <payout tomeType="CurrencyValueDesc" type="GOLD" value="1"/>
    </traps>
    ...snip...
  </battle>
</microtome>
```

* Call `MicrotomeCtx.load`, and you're off!

## Usage

* Ensure python 2.7 is installed
* `$ cd /path/to/microtome`
* `$ python setup.py install` (or `$ sudo python setup.py install`)
* Generate test Microtome "tomes": `$ /path/to/microtome/bin/gen-test-tomes`
* Run the test applications at  `microtome/runtime/src/test/as` (ActionScript) and `microtome/runtime/src/main/objc` (Objective-C).

## Language support

Microtome supports ActionScript, Python, Java, and Objective-C out of the box, and is easily extensible to other languages. To support a new language, you'll need to write a code generator (look at ```Microtome/gentomes/generator_as.py``` and ```Microtome/gentomes/generator_objc.py``` for examples) and a runtime (look at ```Microtome/runtime/src/main/as``` and ```Microtome/runtime/src/main/objc```).

All runtimes currently support XML, but other data formats (such as JSON) are easily supported as well.

