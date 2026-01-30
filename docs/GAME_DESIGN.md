# Discovery Colony
## Game Design Document v0.2

---

## 1. Vision Statement

A survival city-builder set in the Age of Discovery (1500s-1600s). Players lead a small group of colonists arriving by ship to an unfamiliar land. Success requires balancing survival needs, economic growth, diplomatic relationships, and ultimately deciding the colony's destiny—loyal subject of the Crown, independent nation, or something else entirely.

**Core Fantasy:** You are the governor of a fledgling colony, making impossible choices about limited resources, managing relationships with powers far greater than yourself, and building something that might outlast you.

**Inspirations:**
- *Banished* - Survival city-building, population management, seasonal challenges
- *Sid Meier's Colonization* - Colonial trade, independence, native relations
- *Anno series* - Production chains, trade routes, beautiful settlements
- *Frostpunk* - Difficult choices, event-driven narrative (but lighter tone)

**Design Philosophy:**
- **Historical authenticity** - Real nations, real dilemmas, real consequences
- **Mirror, not lecture** - The game reflects player choices without moralizing
- **Hopeful but honest** - Difficult situations, but the tone of Banished not Frostpunk
- **Educational through experience** - Players understand history by living it

---

## 2. Core Gameplay Loop

```
SURVIVE → GROW → TRADE → EXPAND → CHOOSE YOUR DESTINY
   ↑                                        |
   └────────────────────────────────────────┘
```

### The First Year (Tutorial/Early Game)
1. **Landfall** - Choose where to establish your colony
2. **Shelter** - Build basic housing before winter
3. **Food** - Hunt, gather, fish, plant crops
4. **Survival** - Make it through the first winter

### Established Colony (Mid Game)
1. **Production Chains** - Raw materials → refined goods
2. **Trade** - With natives, the Crown, other colonies
3. **Growth** - New colonists arrive, population expands
4. **Challenges** - Disease, raids, political demands

### Colony's Destiny (Late Game)
1. **Accumulate Influence** - Economic, military, diplomatic power
2. **Navigate Politics** - Crown demands vs. colonial interests
3. **Make Your Choice** - Independence, loyalty, or a third path
4. **Legacy** - What kind of society did you build?

---

## 3. Core Systems

### 3.1 Resources

#### Basic Resources (Gathered/Harvested)
| Resource | Source | Use |
|----------|--------|-----|
| Wood | Forests | Construction, fuel, tools |
| Stone | Quarries, surface rocks | Construction |
| Food (various) | Hunting, fishing, farming, gathering | Colonist survival |
| Fresh Water | Rivers, wells | Colonist survival, some production |
| Herbs | Forests, marshes | Medicine |

#### Produced Resources
| Resource | Production Chain | Use |
|----------|------------------|-----|
| Lumber | Wood → Sawmill | Advanced construction |
| Bricks | Clay + Fuel → Brickworks | Advanced construction |
| Tools | Iron + Wood → Blacksmith | All labor efficiency |
| Clothing | Fiber/Leather → Tailor | Colonist warmth/happiness |
| Ale/Spirits | Grain → Brewery | Colonist happiness, trade |

#### Trade Goods (High Value)
| Resource | Production Chain | Notes |
|----------|------------------|-------|
| Furs | Trapping, native trade | Early game export |
| Tobacco | Farming → Curing | Crown highly values |
| Sugar | Farming → Refinery | Very valuable, labor intensive |
| Rum | Sugar → Distillery | Trade good, happiness |
| Salted Fish | Fish → Salting house | Export, preserved food |

### 3.2 Population

#### Colonist Needs (Priority Order)
1. **Food** - Starvation is fatal
2. **Shelter** - Exposure is fatal in winter
3. **Warmth** - Requires fuel in cold months
4. **Health** - Disease prevention and treatment
5. **Happiness** - Affects productivity, prevents unrest

#### Colonist Types
- **Laborers** - General workers, can do any unskilled task
- **Farmers** - Bonus to agricultural output
- **Craftsmen** - Required for advanced production (smiths, carpenters, etc.)
- **Soldiers/Militia** - Defense, can also labor
- **Clergy** - Happiness bonus, can cause religious tension
- **Gentry** - Unhappy doing manual labor, provide governance bonuses

#### Population Growth
- **Natural** - Births (requires families, housing, food surplus)
- **Immigration** - Ships from the Old World (costs money or Crown favor)
- **Integration** - Natives who choose to join (requires good relations)

### 3.3 Buildings

#### Tier 1 - Survival
- Tent / Lean-to (temporary shelter)
- Campfire (cooking, warmth)
- Storage pit
- Fishing spot
- Gathering post

#### Tier 2 - Establishment
- Wooden house
- Storehouse
- Farm field
- Hunting lodge
- Woodcutter's lodge
- Dock (small)

#### Tier 3 - Growth
- Stone/brick buildings
- Blacksmith
- Sawmill
- Church/Meeting house
- Tavern
- Trading post
- Palisade walls

#### Tier 4 - Prosperity
- Governor's mansion
- Fort
- Shipyard
- Warehouse complex
- Multiple production buildings
- Stone walls

### 3.4 Exploration & Cartography

#### Fog of War
The map begins largely unknown. Players see only the immediate landing area.

#### Discovery Methods
- **Scouting** - Send colonists or soldiers to explore (risky)
- **Native Guides** - Trade for knowledge of the land (requires good relations)
- **Expedition** - Organized exploration parties (expensive but thorough)

#### The Cartography System
Unlike most games, discovering territory doesn't give you a perfect satellite view.

**Mapmakers** - A specialist colonist type who creates maps
- Maps are hand-drawn, period-appropriate illustrations
- Accuracy depends on mapmaker skill and time spent
- Early maps may have errors, missing features, wrong distances
- Maps improve over time with multiple surveys
- Beautiful maps become a trade good (sell to Crown, other colonies)

**Map Quality Levels:**
1. **Rough Sketch** - General shapes, major features, many errors
2. **Working Map** - Useful for navigation, some inaccuracies
3. **Detailed Survey** - Reliable, shows resources and terrain
4. **Master Cartography** - Near-perfect, a work of art

**Visual Treatment:**
- Player sees the world through their maps
- Unexplored areas show stylized "here be dragons" illustrations
- Map style evolves with technology and skill
- Creates unique aesthetic different from typical fog of war

### 3.5 Seasons & Time

#### Time Scale
- 1 game day = ~1 minute real time (adjustable)
- 1 game year = ~1 hour real time
- 4 seasons, each with distinct characteristics

#### Seasonal Effects
| Season | Effects |
|--------|---------|
| Spring | Planting season, floods possible, ships arrive |
| Summer | Growing season, highest productivity, disease risk |
| Autumn | Harvest, preparation for winter, storms |
| Winter | Low productivity, high fuel use, no farming, supply ships rare |

---

## 4. Relationship Systems

### 4.1 Native Peoples

**Relationship Spectrum:**
```
HOSTILE ←——— WARY ←——— NEUTRAL ———→ FRIENDLY ———→ ALLIED
```

#### Interactions
- **Trade** - They have food, furs, knowledge; you have tools, cloth, (alcohol?)
- **Learn** - Local crops, medicines, terrain knowledge
- **Land** - Expansion may conflict with their territory
- **Missions** - Clergy may attempt conversion (risky)
- **Conflict** - Raiding in both directions possible

#### Faction Complexity
- Multiple native groups with their own relationships
- Your ally's enemy may become your enemy
- Different groups have different trade goods and knowledge

#### Design Note: Sensitivity
We want to portray native peoples as complex societies with agency, not obstacles or resources. They should:
- Have their own goals and make demands
- Be capable of both friendship and justified hostility
- Offer genuine value through knowledge and trade
- Not be "solvable" - relationships require ongoing maintenance

### 4.2 The Crown

**Relationship measured in:** Crown Favor (0-100)

#### Crown Wants
- Tax revenue (percentage of production or lump payments)
- Specific goods (tobacco, sugar, furs)
- Strategic goals (expand to location X, block rival power)
- Religious conformity (depending on nation)

#### Crown Provides
- New colonists
- Supplies and equipment
- Military support (soldiers, ships)
- Trade agreements
- Governor authority/legitimacy

#### Crown Mechanics
- **Missions** - Complete for favor, ignore for disfavor
- **Taxes** - Pay for favor, evade for disfavor (but keep resources)
- **Reports** - What you tell them vs. reality
- **Royal Governor** - At low favor, Crown may impose their own governor (game over or new challenge?)

### 4.3 Other Powers

#### Rival Colonies
- Compete for resources and territory
- Trade partners or enemies
- May ally against common threats

#### Pirates/Privateers
- Raid trade ships
- Raid coastal settlements
- Can be hired? Bribed?

#### The Church (if separate from Crown)
- Sends missionaries
- Demands religious conformity
- Provides education, healthcare

---

## 5. Historical Authenticity & Moral Complexity

This section addresses how we handle the difficult aspects of colonial history. Our goal is historical honesty without moralizing—the game should be a mirror that reflects player choices back to them.

### 5.1 Design Principles

**Show, Don't Preach**
- No pop-ups saying "slavery is wrong"
- Instead: show the human cost through gameplay systems
- Let players draw their own conclusions from consequences

**17th Century Framing**
- Present choices as people of the era understood them
- Economic arguments, religious justifications, legal frameworks of the time
- Players should understand *why* people made these choices, not just judge them

**Complexity Over Simplicity**
- People are contradictory (Jefferson: slave owner AND "all men are created equal")
- Benefits and costs coexist (native trade partnerships AND exploitation)
- No purely good or evil choices—just choices with consequences

**Earned Understanding**
- Players who engage with slavery should understand its economic appeal
- Players who exploit natives should feel the short-term benefits
- Then they live with the long-term consequences
- This creates deeper understanding than a lecture ever could

### 5.2 Slavery System

**Important:** Slavery is not required. Players can build successful colonies without it. But it exists as a historical reality and a choice.

#### How It Works Mechanically

**Acquisition:**
- Purchase from slave traders (ships arrive periodically)
- Prisoners from conflicts (native or European)
- Costs money but provides labor without ongoing wages

**Economic Reality:**
Enslaved workers provide significant economic advantage:
- No wages (only food, minimal shelter)
- Assigned to labor-intensive work (sugar, tobacco, rice)
- Work longer hours than free colonists
- This is the brutal historical truth—it was profitable

**The Costs (Not Morality Pop-Ups, But Systems):**

*Immediate:*
- Enslaved people are unhappy (affects efficiency over time)
- Require overseers (uses free colonists unproductively)
- Risk of resistance, sabotage, escape
- Some colonists morally opposed (faction tension)

*Social:*
- Free laborers resent competition with unpaid labor
- Class divisions emerge in colony
- Religious colonists may protest
- Native allies may view you differently

*Long-term:*
- Independence becomes harder (Crown may support slavery; rebels may not)
- Enslaved population grows; resistance grows with it
- Your colony's character is shaped by this choice
- Abolition becomes progressively harder and more disruptive

*External:*
- Some European powers begin opposing slavery (historical timeline)
- Abolitionist movements emerge
- Trade partners may refuse to deal with slave colonies
- Your reputation affects diplomacy

#### Paths Forward

**Abolition Arc:**
If players choose to end slavery, it's not simple:
- Economic disruption (who does this labor now?)
- Compensation debates (enslaved people? former owners?)
- Integration challenges (freed people become citizens?)
- Resistance from those who profited
- Potential for violence (historical civil conflicts)

This should feel like a meaningful, difficult transition—not a button press.

**Living With It:**
Players who maintain slavery face escalating challenges:
- Larger enslaved populations require more control
- Resistance movements grow sophisticated
- International pressure increases over time
- The institution becomes harder to maintain

**The Point:**
Players should finish the game understanding:
- Why slavery was economically attractive
- Why it persisted despite moral opposition
- Why ending it was so difficult and bloody
- Why its legacy persists

Not because we told them—because they experienced it.

### 5.3 Native Relations (Expanded)

#### Historical Complexity

**What Natives Gained (Initially):**
- Metal tools, weapons (genuine technological advantage)
- New trade goods and markets
- Alliances against traditional enemies
- Some groups gained power relative to rivals

**What Natives Lost:**
- Land (through purchase, treaty, theft, war)
- Population (disease, violence, displacement)
- Autonomy (increasing European dominance)
- Culture (missionary pressure, forced assimilation)

#### Mechanical Representation

**Trade is Genuinely Beneficial (Early)**
- Native knowledge essential for survival (local crops, medicine, terrain)
- Trade goods valuable to both parties
- Military alliances protect both sides
- This should feel like partnership

**Expansion Creates Pressure**
- Land is finite
- Colonial growth conflicts with native territory
- Treaties can be honored or broken
- Breaking treaties has consequences (war, lost trade, lost knowledge)

**Power Dynamics Shift**
- Early game: natives are powerful, colonists are vulnerable
- Mid game: rough parity, mutual benefit possible
- Late game: colonial power grows, natives face pressure
- This shift should feel earned and consequential

**Disease**
- Historical reality: European diseases devastated native populations
- Not the player's "fault" but a consequence of contact
- Affects native faction strength over time
- Some native groups may blame colonists (historically accurate)

**Multiple Outcomes:**
- **Exploitation** - Broken treaties, land theft, forced labor → wealthy but unstable colony, native resistance
- **Partnership** - Honored agreements, fair trade, cultural exchange → slower growth but stability, unique hybrid culture
- **Conflict** - Open warfare, conquest → military costs, atrocities, international reputation
- **Displacement** - Passive expansion, disease, economic pressure → natives decline without direct violence (but you're still responsible)

### 5.4 The Crown & Colonial Ethics

The Crown may demand things that conflict with player ethics:
- Enforce slavery in the colony
- Break treaties with natives for land
- Persecute religious minorities
- Exploit resources destructively

**Player Agency:**
- Obey (Crown favor, ethical cost)
- Refuse (Crown disfavor, maintain principles)
- Deceive (report compliance, act differently—risky)
- Rebel (eventual independence path)

### 5.5 Representation Guidelines

**Native Peoples:**
- Multiple distinct nations with names, cultures, goals
- Not monolithic "natives" but Powhatan, Wampanoag, Cherokee, etc.
- Leaders with personalities and agendas
- Capable of diplomacy, trade, war, betrayal—full agency
- Their perspective shown (why they make their choices)

**Enslaved People:**
- Individuals when possible, not just labor units
- Resistance shown (escape, sabotage, rebellion)
- Culture and community persist despite oppression
- Abolition involves their agency, not just white saviors

**Colonists:**
- Varied motivations (profit, freedom, religion, adventure, desperation)
- Varied ethics (abolitionists existed alongside slave traders)
- Internal conflicts reflect historical debates

### 5.6 What We're NOT Doing

- **Sanitizing** - We don't pretend atrocities didn't happen
- **Glorifying** - We don't make exploitation feel triumphant
- **Moralizing** - We don't lecture players about right and wrong
- **Simplifying** - We don't reduce complex history to good vs. evil
- **Sensationalizing** - We don't dwell on violence for shock value

### 5.7 The Goal

A player who engages seriously with this game should come away with:
- Deeper understanding of colonial era complexity
- Appreciation for why people made difficult choices
- Recognition of historical consequences we still live with
- Their own conclusions, arrived at through experience

This could be what separates Discovery Colony from other games in the genre.

---

## 6. Events & Narrative

### Random Events (Examples)
- **Supply Ship Delayed** - Expected supplies don't arrive
- **Disease Outbreak** - Colonists fall ill
- **Harsh Winter** - Increased fuel consumption
- **Native Delegation** - Opportunity for diplomacy
- **Pirate Sighting** - Threat to trade
- **Religious Revival** - Happiness boost but potential conflict
- **Gold Rumor** - Colonists want to abandon work to search
- **Mutiny Brewing** - Address colonist grievances or face revolt

### Story Events (Milestone-Triggered)
- **First Winter** - Survival crisis
- **First Contact** - Meeting native peoples
- **Royal Inspector** - Crown evaluates your colony
- **The Question** - First hints of independence sentiment
- **Declaration** - The independence decision

---

## 7. Victory & Endgame

### Victory Paths

#### 1. Loyal Prosperity
- Maintain high Crown favor
- Build wealthy, stable colony
- Become premier colony of the empire
- **Ending:** Appointed Royal Governor for life, colony thrives under Crown

#### 2. Independence
- Build sufficient military/economic strength
- Gain popular support for independence
- Survive the war of independence
- **Ending:** Found a new nation, shape its character

#### 3. Harmonious Integration
- Build strong native alliances
- Create genuinely mixed society
- Resist Crown's more exploitative demands
- **Ending:** Unique cultural synthesis, respected by all parties

#### 4. Trade Empire
- Focus on economic dominance
- Control key trade routes
- Make yourself too valuable to control
- **Ending:** De facto independence through economic power

### Failure States
- **Starvation** - Colony dies out
- **Abandonment** - Colonists leave
- **Conquest** - Destroyed by natives, rivals, or pirates
- **Crown Takeover** - Lose control to royal governor
- **Revolt** - Colonists overthrow you

---

## 8. Art & Aesthetic

### Visual Style (Under Exploration)

We want a **distinctive visual identity**, not generic realism. Current direction to explore:

**Belgian Graphic Novel Inspiration**
- Hergé (Tintin) - Clean lines, clear colors, readable at any scale
- Moebius - Epic landscapes, detailed worlds
- *Ground of Aces* - Modern example of this aesthetic in games

**Potential Characteristics:**
- Strong ink-like outlines
- Flat or limited color palettes
- Stylized but not cartoonish
- Period-appropriate feel (like illustrations from the era)
- Distinctive, immediately recognizable

**Why This Direction:**
- Unique in the city-builder genre
- Connects to the cartography system (maps as art)
- Easier to produce than photorealism
- Ages better than attempts at realism
- Supports the "historical document" feeling

**To Explore Further:**
- Commission concept art in different styles
- Look at historical maps and illustrations for inspiration
- Consider how style affects tone (too whimsical undermines serious themes)

### Audio
- Period-appropriate music (but not intrusive)
- Environmental sounds (forests, ocean, settlement bustle)
- Seasonal audio changes
- Consider: music that reflects colony's moral character?

### UI Philosophy
- Clean, readable, not cluttered
- Information available but not overwhelming
- Advisors/notifications for important events
- Period-appropriate aesthetic (parchment, ink, wax seals)
- Maps integrated into UI (your cartography is your interface)

---

## 9. Technical Considerations (For Later)

### Platform
- PC first (Windows, Mac, Linux)
- Potential console port later

### Engine Options
- **Godot** - Free, open source, good for learning
- **Unity** - Industry standard, lots of resources
- **Unreal** - Powerful but steep learning curve
- **Custom** - Maximum control, maximum effort

### Scope Management
Start with a vertical slice:
1. Basic map with resources
2. Colonists with needs
3. Building placement
4. Simple production chains
5. One year of seasons

Then iterate and expand.

---

## 10. Decisions Made

These questions have been resolved:

| Question | Decision |
|----------|----------|
| Real vs. alt-history | **Real history** - England, Spain, France, etc. Educational value. |
| Map generation | **Hand-crafted maps** with fog of war and cartography system |
| Multiple colonies | **Single colony for MVP**, Manor Lords-style expansion later |
| Multiplayer | **No** - Single player only for now |
| Mod support | **No** - Not a priority for MVP |
| Tone on colonialism | **Honest and complex** - See Section 5 |
| Tone overall | **Hopeful like Banished**, not heavy like Frostpunk |

## 11. Open Questions (Remaining)

1. **Difficulty modes** - How do we scale challenge? Fewer resources? More aggressive natives/rivals? Harsher winters?

2. **Starting scenarios** - Which colonial power do you play? Different starts for England vs. Spain vs. France?

3. **Time period** - Exact years? 1580-1680? 1600-1776? Does it extend to American Revolution?

4. **Specific nations represented** - Which native nations? Which colonial powers? How many of each?

5. **Tech stack** - Which game engine? (See Section 9)

6. **Visual style confirmation** - Need concept art exploration before committing

---

## 12. Next Steps

### Immediate
1. ~~Answer open questions~~ → Most resolved (see Section 10)
2. **Explore visual style** - Gather references, possibly commission concept art
3. **Choose tech stack** - Engine decision needed before prototyping

### Prototype (Vertical Slice)
4. **Basic map** with resources and fog of war
5. **Colonists** with needs (food, shelter, warmth)
6. **Building placement** (Tier 1-2 buildings)
7. **Simple production chains** (wood → lumber, etc.)
8. **One year of seasons** with effects
9. **Basic native contact** (trade, simple relations)

### Then Iterate
10. Playtest core loop - Is it fun?
11. Add complexity based on what works
12. Revisit scope based on learnings

---

*Document Version: 0.2*
*Last Updated: 2026-01-30*
*Status: Core decisions made, ready for visual exploration and tech stack selection*
