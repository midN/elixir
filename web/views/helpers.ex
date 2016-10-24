defmodule Stockman.Helpers do
  @moduledoc false

  def cartman_quote do
    [
      "Mom! Ben Affleck is naked in my bed!",
      "I've lost almost ten pounds now. You see what I mean? I totally know what it's like to be a Jew in the Holocaust now.",
      "Oh yeah? I run with 12 gangs, and we only commit hate crimes! Whateva! I do what I want!",
      "I checked on the internet, Kyle, and getting Butters to put my wiener in his mouth wouldn't make me not gay!",
      "I want to get down on my knees and start pleasing Jesus. I want to feel his salvation all over my face.",
      "Your tears are so yummy and sweet. Ohhh, the tears of immeasurable sadness! Yummy, you guys!",
      "I would never let a woman kick my ass. If she tried something, I’d be like, HEY! You get your bitch ass back in the kitchen and make me some pie!",
      "Too bad drinking scotch isn’t a paying job or Kenny’s dad would be a millionaire!",
      "Well I looked in my moms closet and saw what I was getting for Christmas, an ultravibe pleasure 2000.",
      "Kenny’s family is so poor that yesterday, they had to put their cardboard box up for a second mortgage."
    ]
    |> Enum.random
  end
end
