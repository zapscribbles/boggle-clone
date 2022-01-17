# Game Flow

## Brainstorm

``` mermaid
graph TD
    start[Start Battle <br/> Begin a battle with a new enemy, or continue battling an enemy]
    summon[Summon Runes <br/> Letters are laid out in the grid <br/> Costs in-game currency? <br/> Or limit, 2/day?]
    happy{Happy with runes?}
    draw[Draw Spells <br/> Words are formed by connecting adjacent letters <br/> Each word is a spell <br/> Has a time limit]
    finalise[Finalise drawn runes <br/> Timer stops ]
    timeout[Enemy starts attacking psummoner <br/> unchallenged, reducing their health]
    cast[Cast spell<br/> Choose a spell to cast]
    enemyturn[Enemy fights back <br/> Need to beat their spell power each cast? Like Dice Mage 2?]
    playerdefeated[Psummoner defeated?]
    enemydefeated{Enemy defeated?}
    spellsleft{Are any spells left}
    finish[Battle Complete]
    rewards[Gain rewards <br/> XP, fa:fa-dollar-sign, loot etc.]
    start ---> summon ---> happy
    happy ---> |Yes| draw
    happy ---> |No <br/> Penalty? higher cost, or another currency?| summon
    draw --> finalise --> cast
    cast ---> enemydefeated
    draw --- |Time limit reached| timeout
    enemydefeated ---> |Yes| finish --> rewards
    enemydefeated ---> |No| enemyturn --> playerdefeated
    playerdefeated ---> |Yes| start
    playerdefeated ---> |No| spellsleft
    spellsleft --> |Yes| cast
    spellsleft --> |No| summon
```

* Letters = Runes
* Words = Spells

### Spells
* Spells are powered based on number of letters in their word
* Qu rune counts as two letters
* Runes that are uncommon (like Qu) are embued with extra power, strengthening the spell


## MVP

* Draw and Cast are the same thing - spells are cast as soon as they are drawn
* Each word is a spell, word length determines spell power (Qu counts as two letters)
* Constant stream of enemies while timer is going - once one is defeated, another appears
* Overkilling an enemy (doing more damage than needed to kill it) dissipates remaining spell power (strategic value in holding off on longer words until needed)
* Enemy helth and spell power clearly visually represented. Enemy health can display as dots when within range of maximum spell power, to help player prevent wasting spell power
* XP calculation contributions
    - Total num words found
    - Word lengths found (x per 3-letter word, y per 4-letter word)
* $ calculation contributions
    - Each enemy gives range of $'s based on their power

``` mermaid
graph TD
    start[Start Battle <br/> Begin a battle with a new enemy, or continue battling an enemy]
    summon[Summon Runes <br/> Letters are laid out in the grid <br/> Costs in-game currency? <br/> Or limit, 2/day?]
    happy{Happy with runes?}
    timestart[Timer starts]
    spawn[New enemy spawns]
    cast[Cast Spells <br/> Spells are cast by connecting adjacent letters to form words]
    timeout[Time has run out <br/> Battle over ]
    enemydefeated[Enemy defeated?]
    rewards[Gain rewards <br/> XP, fa:fa-dollar-sign, special currency]
    start ---> summon ---> happy
    happy ---> |Yes| timestart & spawn & cast
    happy ---> |No <br/> Penalty? higher cost, or another currency?| summon
    cast --> enemydefeated
    cast ---> |Time limit reached| timeout --> rewards
    enemydefeated --> |Yes| spawn
```

### Extensions

* Horde Mode - enemies spawn regardless if previous enemy has been defeated. Higher difficulties mean higher spawn rates. Total health of all enemies adds up to a "horde power" - once horde power reaches a certain threshold, game over (like a timeout)
* Speed Mode - Set number of enemies. once defeated, round is complete - completing round before the timer finishes earns extra points.
* Floating grabs - special grabs floating arpund enemy to grab - extra $, special resources etc.
