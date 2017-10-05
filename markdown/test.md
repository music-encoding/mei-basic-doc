# Notes, Chords and Rests

In MEI, notes, chords and rests are often referred to as *events*.
These events are the most basic and important part of MEI.

## Notes

This is how you encode a single note in MEI:
 
[basic note example](eg:basic_note.mei "//*:note")

As you can see, the most relevant information is split into three different
attributes for easier processing. Every note requires to have a pitch name. The
**@pname** attribute may hold the following values: *c*,
*d*, *e*, *f*, *g*, *a*,
*b*.
            
The second part of the information about pitch is stored in the **@oct**
attribute. Octaves are given according to the Acoustical Society of America
representation, which means the middle C on a piano will have a value of
*4*, the octave above will have a *5*, the one below a
*3* and so on.

Each note needs to have a duration being set. This is done with the **@dur**
attribute. Values are integers that match the note's duration, i.e. a quarter note
will use a value of *4*, an eigth note will use *8* and so
forth. In case of a dotted note, the *optional*
**@dots** attribute is used to indicate the number of dots.

##Chords
 
In MEI Basic, chords strictly share a duration, that is, all notes need to have the
same duration. Accordingly, the **@dur** (and **@dots**, if necessary)
attribute(s) are a property of the chord, but not the individual notes anymore.

[basic chord example](eg:basic_chord.mei "//*:chord")

MEI Basic makes no assumption on the order of child notes in a chord – you can start
either from the highest or lowest pitch, or mix them as you like.

##Rests

The duration of rests is specified the same way as for notes or chords, that is,
using **@dur**, and, if necessary, **@dots**.

[basic rest example](eg:basic_rest.mei "//*:rest")

Do I need to say more?

# Problems of the markdown approach so far:

- soCalled has no direct match -> used italics
- eg isn't possible -> just use specially formatted links?

## Possible links
General structure of links (according to Oxygen): [text](file.url "title")

- [//*:rest](eg:basic.mei)
- [//*:measure[1]/*:slur](eg:basic_slur1.mei) doesn't understand the square brackets correctly
- [Slur example](eg:basic_slur1.mei "//*:measure[1]/*:slur") is better as it still allows to use ticks
- elements: [staffDef](elem:staffDef) – this could be adjusted for model classes etc. as well

In the CMN chapter, we use the following elements: 

- div *implicitly possible through heading structure*
- head 
- p
- **soCalled**
- **term**
- ref
- ptr
- **gi**
- **ident**
- egXML
- **att**
- **specList**
- **specDesc**
- list
- item
- **label** *this depents on the position*
- figure
- graphic
- emph
- **expan**
- **foreign**
- **title** *this depends on the position*

The ones written in bold have no direct match in Markdown
