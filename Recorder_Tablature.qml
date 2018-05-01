//=============================================================================
//  MuseScore
//
//  Recorder Woodwind Tablature plugin
//
//  Copyright (C)2011 Dario Escobedo, Werner Schweer, Jens Iwanenko and others
//  This is a variation of Werner Schweer very famous recorder_fingering plugin,
//  using Matthew Hindson Woodwind Tablature font. This font is located at 
//  http://www.hindson.com.au/fonts/RecorderTablature.zip. Dario Escobedo, Werner
//  Schweer and others are not the owners of the the font itself.
//
//  Modified for MuseScore 2 in 2016 by Maksim Samsyka. And use new Recorder font
//  created by Alberto Gomez Gomez (algomgom@gmail.com) on July 26, 2006, and
//  located at http://www.fontspace.com/algomgom/recorder
//  This font was modified too to include Yamaha fingerings.
//
//  Further modified and simplified in 2018 by Jens Iwanenko. Now uses only 1 plugin
//  the actual flute style can be selected with the font size in the popup window.
//
//  This program is free software; you can redistribute it and/or modify
//  it under the terms of the GNU General Public License version 2.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program; if not, write to the Free Software
//  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
//=============================================================================

import QtQuick 2.4
import QtQuick.Dialogs 1.2
import QtQuick.Controls 1.3
import MuseScore 1.0

MuseScore {
      version: "2.1"
      description: "Place recorder tablature under notes. Font size and fingering style can be selected. Be aware that you need a special Recorder font installed on your system."
      menuPath: "Plugins.Add Recorder Tablature"
      pluginType: "dialog"
      
      id:window
      width: 300; height: 150;

    Label {
        id: labelStyle
        anchors.left: window.left
        anchors.top: window.top
        anchors.leftMargin: 10
        anchors.topMargin: 10
        width: 130
        height: 20
        text: qsTr("Whistle key")
        verticalAlignment: Text.AlignVCenter
        wrapMode: Text.WordWrap
    }

    ComboBox {
        id: styleSelect
        anchors.left: labelStyle.right
        anchors.top: window.top
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        anchors.topMargin: 10
        width: 140
        height: 20
        currentIndex: 0
        model: ["Baroque",
                "German"]
    }

    Label {
        id: labelVoice
        anchors.left: window.left
        anchors.top: labelStyle.bottom
        anchors.leftMargin: 10
        anchors.topMargin: 10
        width: 130
        height: 20
        text: qsTr("Whistle key")
        verticalAlignment: Text.AlignVCenter
        wrapMode: Text.WordWrap
    }

    ComboBox {
        id: voiceSelect
        anchors.left: labelVoice.right
        anchors.top: styleSelect.bottom
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        anchors.topMargin: 10
        width: 140
        height: 20
        currentIndex: 1
        model: ["Alto",
                "Soprano"]
    }

    Label {
        id: labelSize
        anchors.left: window.left
        anchors.top: labelVoice.bottom
        anchors.leftMargin: 10
        anchors.topMargin: 10
        width: 130
        height: 20
        text: qsTr("Text size")
        verticalAlignment: Text.AlignVCenter
        wrapMode: Text.WordWrap
    }

    SpinBox {
        id: fontSize
        anchors.left: labelSize.right
        anchors.top: voiceSelect.bottom
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        anchors.topMargin: 10
        width: 140
        height: 20
        minimumValue: 15
        maximumValue: 60
        value: 35
        transformOrigin: Item.Center
    }

      Button {
        id : buttonOk
        text: qsTr("Ok")
        anchors.right: window.right
        anchors.top: fontSize.bottom
        anchors.rightMargin: 10
        anchors.topMargin: 10
        width: 75
        height: 20
        isDefault: true
        onClicked: {
            curScore.startCmd();
            if(styleSelect.currentIndex < 0)
              styleSelect.setCurrentItem(0); // Default to Baroque
            if(voiceSelect.currentIndex < 0)
              voiceSelect.setCurrentItem(1); // Default to Soprano
            placeTab(fontSize.value,styleSelect.currentIndex,voiceSelect.currentIndex);
            curScore.endCmd();
            Qt.quit();
            }
        }

      //                                c    c#   d    d#   e    f    f#   g    g#   a    a#   b 
      // C    C#   D    D#   E    F    F#   G    G#   A    A#   B    c    c#   d
      property variant styles : [[ "a", "z", "s", "x", "d", "f", "v", "g", "b", "h", "n", "j",
        "q", "2", "w", "3", "e", "r", "5", "t", "6", "y", "7", "u", "i", "9", "o"],
                                     [ "A", "Z", "S", "X", "D", "F", "V", "G", "B", "H", "N", "J",
        "Q", "@", "W", "#", "E", "R", "%", "T", "^", "Y", "&", "U", "I", "(", "O"]]
      //                            Alto  Soprano
      property variant voicePitch : [65,  72]
      function placeTab(size,style,voice){
            var cursor   = curScore.newCursor();
            var fingerings = styles[style];
            var basePitch = voicePitch[voice];
            cursor.staffIdx = 0; // start on first staff
            cursor.voice = 0; // hope that only one voice in score, for recorder :)
            cursor.rewind(0);  // set cursor to start of score
            while (cursor.segment) { // in end segment is null
                  if (cursor.element._name() == "Chord") {
//console.log(cursor.element.stafftext.parent._name());                  
                        var pitch = cursor.element.notes[0].pitch;
                        var index = pitch - basePitch;
                        if(index >= 0 && index < fingerings.length){ 
                              var text = newElement(Element.STAFF_TEXT);
                              text.text = "<font face=\"Recorder Font\"/>"+fingerings[index];
                              text.text = "<font size=\""+size+"\"/>"+text.text;
                              text.text = text.text + "</font></font>";
console.log(text.text);
                              text.pos.y = 10;
                              cursor.add(text);
                        }// end if
                  }// end if
                  cursor.next();
            }// end while
      }

      onRun: {
            console.log("Hello from Recorder Woodwind Tablature");

            if (typeof curScore === 'undefined')
                  Qt.quit();

//            placeTab();
  
//            Qt.quit();
      }
}