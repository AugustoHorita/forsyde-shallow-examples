-----------------------------------------------------------------------------
-- |
-- Module      :  AdaptiveAmp
-- Copyright   :  José Edil Guimarães de Medeiros
-- License     :  BSD-style (see the file LICENSE)
-- 
-- Maintainer  :  j.edil@ene.unb.br
-- Stability   :  experimental
-- Portability :  portable
--
-- This is the synchronous model for the amplifier example developed throughout
-- the chapter 3 of Axel's book.
-- A block diagram can be found in Figure 3-7.
-- 
-----------------------------------------------------------------------------

module AdaptiveAmp where

import ForSyDe.Shallow

-- adaptiveAmp Netlist
adaptiveAmp :: (Ord a, Num a) => Signal a -> Signal a
adaptiveAmp sin = sout
    where   s1 = p1 s3 sin           -- process A1
            sout = p2 s1
            s2 = p3 sout
            s3 = p4 s2                -- process A4

-- Process A1: zips the input and the control signal
p1 :: Num a => Signal a -> Signal a -> Signal ([a], [a])
p1 = zipSY 1 5

-- Process A2: amplification function
p2 :: Num a => Signal ([a], [a]) -> Signal a
p2 = mapSY 1 mult
    where   mult [([control], signal)] = map (* control) signal

-- Process A3: decides if the output is too big
p3 :: (Ord a, Num a) => Signal a -> Signal a
p3 = scanSY (\_ -> 5) g 10   -- process A3
                where   g :: (Ord a, Num a) => a -> [a] -> a
                        g state signal 
                            | sum signal > 500  = state - 1
                            | sum signal < 400  = state + 1
                            | otherwise         = state

-- Process A4: signal initiator
p4 :: (Num a) => Signal a -> Signal a
p4 = delay 10             
