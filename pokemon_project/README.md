Pokedex Project

### User Stories

// NOTE: - `#warnings` are provided in the code as indicators on where to complete parts of the stories listed below. Please delete all `#warnings` before submission

1. As a __developer__, I need to finish implementing `Decodable` initializers and `CodingKeys` for the structs provided so that I am able to parse the data returned from service calls. Structs included in this requirement are as follows:
    - `Pokemon`:
        - Implement `CodingKeys`
        - Implement `init(from decoder: Decoder)`
        - // NOTE: - `sprites` should be decoded as a `SpritesFromService` object and set using the `sprites` property from that decoded object
    - `Ability`:
        - Implement `CodingKeys`
    - `HeldItem`:
        - Implement `CodingKeys`
    - `Move`:
        - Implement `CodingKeys`
    - `Stat`:
        - Implement `CodingKeys`
    - `VersionGameIndex`, `VersionGroupDetail`:
        - Implement `CodingKeys`
    - // NOTE: - `CodingKeys` cases **MUST** reflect the naming conventions employed by their corresponding struct-properties. The `rawValue` should reflect the keys found in the **json**
2. As a user I need to see a list of **Pokémon** I've caught
    - This will be the initial screen of your app
    - You will complete this work in the **My Pokemon List** directory
    - An empty storyboard file is provided for you
    - Implement a `UITableView` that displays a list of `CaughtPokemon` added by the user
    - In your `MyPokemonList` storyboard, create a `UINavigationController` and link it as the __root ViewController__ to the ViewController containing the table view. This will be important for navigating throughout the app later
    - Add a `UIBarButtonItem` to the `NavigationItem` in your `MyPokemonList` storyboard. Tapping this button should trigger a `UIStoryboardSegue` to an **EditPokemon** scene where a user can add another `CaughtPokemon` to their list
    - Tapping on a table view cell should trigger a `UIStoryboardSegue` to that same **EditPokemon** scene, however it should be populated with the attributes of the `CaughtPokemon` who's cell was tapped on in the previous scene
3. As a user I need to be able to add a `CaughtPokemon` to my list
    - `CaughtPokemon` struct already provided
    - You will complete this work in the **Edit Pokemon** directory
    - The user should be able to supply the following input:
        - **Pokemon Species**
            - The user may select from a list of **Pokemon Species**. The **Species Selection** directory contains code for this selection. It will use the `PokemonServiceClient` to complete a service call to [PokéApi](https://pokeapi.co/docs/v2.html/). You **MUST** implement the segue to this scene and properly consume the data returned from a user's selection
        - **NickName**, **CurrentLevel**, and **CurrentExperience** should be entered via `UITextField`'s.
            - **NickName** **MUST** be at least 3 characters long
            - **CurrentLevel** and **CurrentExperience** **MUST** be numbers
        - **Moves**, **Sprite** and **HeldItem** should be selected from a list displayed to the user.
            - The **Select Option** directory contains code for this selection. You **MUST** implement the segue to this scene and properly consume the data returned from a user's selection
            - **Moves** **MUST** contain at least one selected item. **Sprite** must return valid data to display an image
            - These properties should not be accessible for selection **Until the user has selected a species**
    - A `UIImageView` containing a `UIImage` of the selected sprite must be visible on your creation/edit scene. You will use the `PokemonServiceClient` provided to fetch the available sprite images. If the user has not yet chosen a sprite, set this image to the provided `pokeball.pdf` provided in **Assets.xcassets**
    - A **Save** button should be available in the **NavigationBar**. All user input should be validated so that this button is enabled/disabled properly
4. As a user I need to be able to edit my `CaughtPokemon`
    - By this point, most of this story should be in place. Any changes made to a `CaughtPokemon` while editing must be persisted and reflected in the **My Pokemon List** model
5. As a user I need my `CaughtPokemon` list to be persisted
    - `PokemonPersistence` is provided for you along with all of the necessary `FileManager` extensions. All data changes **MUST** be persisted properly
6. As a user I want to be able to **release** (AKA **delete**) a pokemon from my `CaughtPokemon` list
    - Implement deletion for a **single** `CaughtPokemon` at a time. All data changes **MUST** be persisted properly. You will have to add the **delete** function to persistence

### Technical Requirements

1. **USE MVC**: That means you need a Model file that handles the logic of tracking all additions/removals/edits to the `CaughtPokemon` list, as well as a Model file to handle validations and problem logic while creating/editing a `CaughtPokemon`
2. **USE AUTOLAYOUT**: You can use stack views to make it a lot easier, but you need basic constraints to the app could be used on several different sizes of device.
3. Use a table view for the `CaughtPokemon` list. The app is also currently set up for implementing the creation/edit scene as a `UITableView` as well
4. All scenes must be implemeted in **different storyboard files**. **DO NOT** chain all of your scenes in one giant storyboard
5. **DO NOT** change the names or types of any of the structs (or their properties) provided. They are there to assist you and specific criteria for this project is built around them

    

