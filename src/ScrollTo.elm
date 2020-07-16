module ScrollTo exposing
    ( Status, Msg
    , init, update, subscriptions
    , toPosition
    , withDelay, withDuration, withEasing
    )

{-|

@docs Status, Msg


# Setup

@docs init, update, subscriptions


# Run the Scroll Animation

@docs toPosition


# Animation Customizations

@docs withDelay, withDuration, withEasing

-}

import Browser.Dom
import Browser.Events
import ScrollTo.Animation as Animation
import Task
import Debug


{-| Represent the state of the scroll; the status will remain waiting until a
scroll command is issued.

    type alias Model =
        { scrollToStatus : ScrollTo.Status }}

-}
<<<<<<< Updated upstream
type Status
    = Waiting Animation.Animation
=======
type Status msg
    = Waiting 
        { animation : Animation.Animation
        , target : Target
        , usrMsg : Msg -> msg
        }
>>>>>>> Stashed changes
    | Animating
        { scene : Dimensions
        , to : Position
        , from : Position
        , animation : Animation.Animation
        , elapsed : Float
<<<<<<< Updated upstream
=======
        , target : Target
        , usrMsg : Msg -> msg
>>>>>>> Stashed changes
        }


type alias Dimensions =
    { height : Float
    , width : Float
    }


type alias Position =
    { x : Float
    , y : Float
    }


{-| Setup a basic scroll command.

    ScrollTo.init

-}
<<<<<<< Updated upstream
init : Status
init =
    Waiting Animation.init
=======
init : ( Msg -> msg ) -> Status msg
init usrMsg =
    Waiting 
        { animation = Animation.init
        , target = Window
        , usrMsg = usrMsg
        }


{-| Setup a scroll command for a specific scrollable element 
    (not the whole window)

    ScrollTo.initFor "element-id"

-}
initFor : ( Msg -> msg ) -> String -> Status msg
initFor usrMsg id =
    Waiting
        { animation = Animation.init
        , target = Element id
        , usrMsg = usrMsg
        }
>>>>>>> Stashed changes


{-| Add a delay (in ms) to your scroll command.

    -- default: 0
    ScrollTo.withDelay 1000

-}
withDelay : Float -> Status msg -> Status msg
withDelay delay scroll =
    case scroll of
        Waiting animation ->
            Waiting <| Animation.withDelay delay animation

        _ ->
            scroll


{-| Add a duration (in ms) to your scroll command.

    -- default: 1000
    ScrollTo.withDuration 5000

-}
withDuration : Float -> Status msg -> Status msg
withDuration duration scroll =
    case scroll of
        Waiting animation ->
            Waiting <| Animation.withDuration duration animation

        _ ->
            scroll


{-| Add an easing function
([elm-community/easing-functions](https://package.elm-lang.org/packages/elm-community/easing-functions/latest))
to your scroll command.

    -- default: identity (linear)
    ScrollTo.withEasing Ease.inOutQuint

-}
withEasing : (Float -> Float) -> Status msg -> Status msg
withEasing easing scroll =
    case scroll of
        Waiting animation ->
            Waiting <| Animation.withEasing easing animation

        _ ->
            scroll


{-| Scroll to a position offset on the screen.

    -- to the top!
    ScrollTo.toPosition { x = 0, y = 0 }

    -- to x offset
    ScrollTo.toPosition { x = 1080, y = 0 }

    -- to y offset
    ScrollTo.toPosition { x = 0, y = 540 }

    -- to x,y offset
    ScrollTo.toPosition { x = 1080, y = 540 }

-}
<<<<<<< Updated upstream
toPosition : Position -> Cmd Msg
toPosition to =
    Task.perform (GotViewport to) Browser.Dom.getViewport
=======
toPosition : Position -> Status msg -> Cmd Msg
toPosition to scroll =
    let 
        tgt = {-for either whole window of scrollable elment-}
            case scroll of
                Waiting { target } ->
                    target
                Animating { target } ->
                    target
    in
        let 
            task = 
                case tgt of 
                    Window ->
                        Browser.Dom.getViewport
                    Element id ->
                        Browser.Dom.getViewportOf id
        in
            Task.attempt (GotViewport to) task
>>>>>>> Stashed changes


{-| Track scroll messages.

    type Msg
        = ScrollToMsg ScrollTo.Msg

-}
type Msg
    = GotViewport Position Browser.Dom.Viewport
    | StartAnimation Position Browser.Dom.Viewport
    | Step Float
    | NoOp


{-| Handle updates from the scroll animation.

    ScrollTo.update scrollToMsg model.scrollToStatus msg

-}
update : Msg -> Status msg -> ( Status msg, Cmd msg )
update msg scroll =
    case msg of
<<<<<<< Updated upstream
        GotViewport to viewport ->
            case scroll of
                Waiting animation ->
                    ( scroll
                    , Animation.wait animation <| StartAnimation to viewport
                    )

                Animating { animation } ->
                    ( scroll
                    , Animation.wait animation <| StartAnimation to viewport
                    )

        StartAnimation to { scene, viewport } ->
            case scroll of
                Waiting animation ->
=======
        GotViewport to result ->
            case result of
                Ok viewport ->
                    case scroll of
                        Waiting { animation, usrMsg } ->
                            ( scroll
                            , Animation.wait animation <| 
                                usrMsg <|
                                    StartAnimation to viewport
                            )

                        Animating { animation, usrMsg } ->
                            ( scroll
                            , Animation.wait animation <| 
                                usrMsg <|
                                    StartAnimation to viewport
                            )
                Err _ ->
                    ( scroll, Cmd.none)

        StartAnimation to { scene, viewport } ->
            case scroll of
                Waiting { animation, target, usrMsg } ->
>>>>>>> Stashed changes
                    ( Animating
                        { scene = { height = scene.height, width = scene.width }
                        , to = to
                        , from = { x = viewport.x, y = viewport.y }
                        , animation = animation
                        , elapsed = 0
<<<<<<< Updated upstream
=======
                        , target = target
                        , usrMsg = usrMsg
>>>>>>> Stashed changes
                        }
                    , Cmd.none
                    )

<<<<<<< Updated upstream
                Animating { animation } ->
=======
                Animating { animation, target, usrMsg } ->
>>>>>>> Stashed changes
                    ( Animating
                        { scene = { height = scene.height, width = scene.width }
                        , to = to
                        , from = { x = viewport.x, y = viewport.y }
                        , animation = animation
                        , elapsed = 0
<<<<<<< Updated upstream
=======
                        , target = target
                        , usrMsg = usrMsg
>>>>>>> Stashed changes
                        }
                    , Cmd.none
                    )

        Step delta ->
            case scroll of
<<<<<<< Updated upstream
                Animating ({ to, from, animation, elapsed, scene } as data) ->
=======
                Animating ({ to, from, animation, elapsed, scene, target, usrMsg } as data) ->
>>>>>>> Stashed changes
                    let
                        time =
                            delta + elapsed

                        step =
                            Animation.step time animation
                    in
                    if Animation.isFinished animation time then
<<<<<<< Updated upstream
                        ( Waiting animation
                        , Task.perform (\_ -> NoOp) <|
                            Browser.Dom.setViewport to.x to.y
=======
                        ( Waiting { animation = animation, target = target, usrMsg = usrMsg }
                        , Task.attempt (\_ -> usrMsg NoOp) <|
                            task to.x to.y
>>>>>>> Stashed changes
                        )

                    else
                        ( Animating { data | elapsed = time }
<<<<<<< Updated upstream
                        , Task.perform (\_ -> NoOp) <|
                            Browser.Dom.setViewport
=======
                        , Task.attempt (\_ -> usrMsg NoOp) <|
                            task
>>>>>>> Stashed changes
                                (clamp 0
                                    scene.width
                                    (from.x + (to.x - from.x) * step)
                                )
                                (clamp 0
                                    scene.height
                                    (from.y + (to.y - from.y) * step)
                                )
                        )

                _ ->
                    ( scroll, Cmd.none )

        NoOp ->
            ( scroll, Cmd.none )


{-| Subscribe to scroll animation updates.

    ScrollTo.subscriptions ScrollToMsg model.scrollToStatus

-}
subscriptions : Status msg -> Sub msg
subscriptions scroll =
    case scroll of
        Animating { usrMsg } ->
            Browser.Events.onAnimationFrameDelta (\delta -> usrMsg <| Step delta)

        _ ->
            Sub.none
