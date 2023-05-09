#!/usr/bin/env raku
use v6.e.*;

#unit module Forest;

role iNode {}

class OutNode does iNode {
    has @.point;

    method List {
        @!point.List
    }
}

class InNode does iNode {
    has iNode $.left;
    has iNode $.right;
    has $.split-point;

    method List {($.left.List, $.right.List)}
}

multi tree-from-points (
    +@point,
    :$depth = 0,
    :$max-depth = @point.elems.log(2).ceiling,
    :&get-split-point
    where ($depth >= $max-depth or @point.elems ≤ 1)
) {
   OutNode.new: :@point
}

multi tree-from-points (
    +@point,
    :$depth = 0,
    :$max-depth = @point.elems.log(2).ceiling,
    :&get-split-point
) {

   my $split-point := get-split-point @point;
   my $child := \( depth => $depth +1, :$max-depth, :&get-split-point);
   my %splited-points := @point.classify: * ≤ $split-point;
   InNode.new(
       left  => tree-from-points( |%splited-points{True}, |$child ),
       right => tree-from-points( |%splited-points{False}, |$child ),
       :$split-point,
   )
}

multi MAIN (Bool :test($)!) {
    use Test;
    my $tree = tree-from-points (3,2,4,1), get-split-point => { .head(2).sum/2 }, :2max-depth  ;
    is-deeply $tree.List, (((1,),(2,)),((3,),(4,)));
    my $tree2 = tree-from-points (2,1,4,3), get-split-point => { .head(2).sum/2 }, :2max-depth  ;
    is-deeply $tree2.List, ((1,),((2,3),(4,)));
    my $tree2b = tree-from-points (2,1,4,3), get-split-point => { .sum/.elems }, :2max-depth  ;
    is-deeply $tree2b.List, (((1,),(2,)),((3,),(4,)));
    my $tree3 = tree-from-points (1..4), get-split-point => { .head }, :3max-depth  ;
    is-deeply $tree3.List, ((1,),((2,),((3,),(4,))));
    todo 'Jak by to mělo fungovat?';
    my $tree4 = tree-from-points (1..4), get-split-point => { .tail }, :4max-depth  ;
    is-deeply $tree4.List, ((1,),((2,),((3,),(4,))));
    done-testing;
}

multi MAIN (*@a) {
    say @a  ;
}
