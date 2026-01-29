# Discovery Colony
## Game Design Document v0.1

---

## 1. Vision Statement

A survival city-builder set in the Age of Discovery (1500s-1600s). Players lead a small group of colonists arriving by ship to an unfamiliar land. Success requires balancing survival needs, economic growth, diplomatic relationships, and ultimately deciding the colony's destiny—loyal subject of the Crown, independent nation, or something else entirely.

**Core Fantasy:** You are the governor of a fledgling colony, making impossible choices about limited resources, managing relationships with powers far greater than yourself, and building something that might outlast you.

**Inspirations:**
- *Banished* - Survival city-building, population management, seasonal challenges
- *Sid Meier's Colonization* - Colonial trade, independence, native relations
- *Anno series* - Production chains, trade routes, beautiful settlements
- *Frostpunk* - Difficult moral choices, event-driven narrative

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

### 3.4 Seasons & Time

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

## 5. Events & Narrative

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

## 6. Victory & Endgame

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

## 7. Art & Aesthetic

### Visual Style (TBD)
Options to consider:
- **Realistic** - Anno-style detailed 3D
- **Stylized** - Northgard-style painterly
- **Pixel Art** - Retro aesthetic, faster to produce
- **Minimalist** - Abstract, focus on systems

### Audio
- Period-appropriate music
- Environmental sounds (forests, ocean, settlement bustle)
- Seasonal audio changes

### UI Philosophy
- Clean, readable, not cluttered
- Information available but not overwhelming
- Advisors/notifications for important events

---

## 8. Technical Considerations (For Later)

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

## 9. Open Questions

1. **Real history or alt-history?** - Specific nations (England, Spain, France) or fictional powers?

2. **Map generation** - Procedural or hand-crafted scenarios?

3. **Multiple colonies?** - Manage one colony or eventually multiple settlements?

4. **Multiplayer?** - Solo only or competitive/cooperative multiplayer?

5. **Mod support?** - Priority for community content?

6. **Tone on colonialism** - How directly do we address historical atrocities? Do we allow slavery? (Recommend: no, or only as a system you must abolish)

7. **Difficulty modes** - How do we scale challenge?

---

## 10. Next Steps

1. **Refine this document** - Answer open questions, add detail where needed
2. **Create detailed system specs** - Deep dive on each major system
3. **Choose tech stack** - Engine, language, tools
4. **Prototype core loop** - Colonists, needs, building, seasons
5. **Playtest and iterate** - Is it fun?

---

*Document Version: 0.1*
*Last Updated: 2026-01-29*
*Status: Initial Draft - Ready for Feedback*
