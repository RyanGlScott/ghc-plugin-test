{-# LANGUAGE CPP #-}
module TestPlugin (plugin) where

import CoreMonad
import GhcPlugins
import HscTypes
import Outputable

plugin :: Plugin
plugin = defaultPlugin {
  installCoreToDos = install
}

install :: [CommandLineOption] -> [CoreToDo] -> CoreM [CoreToDo]
install _ todo = do
  reinitializeGlobals
  putMsgS "Hello!"
  return $ CoreDoPluginPass "Say module name" pass : todo

pass :: ModGuts -> CoreM ModGuts
pass guts = do
  dflags <- getDynFlags
#if defined(mingw32_HOST_OS)
  putMsgS "Will this crash on Windows?"
#endif
  putMsgS $ showPpr dflags (mg_module guts)
#if defined(mingw32_HOST_OS)
  putMsgS "Nope"
#endif
  return guts