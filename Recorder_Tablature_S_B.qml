//=============================================================================
//  MuseScore
//
//  Recorder Woodwind Tablature plugin
//
//  Copyright (C)2011 Dario Escobedo, Werner Schweer and others
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

import QtQuick 2.1
import QtQuick.Dialogs 1.0
import QtQuick.Controls 1.0
import MuseScore 1.0

MuseScore {
      version: "2.0"
      description: "Place recorder tablature under notes"
      menuPath: "Plugins.Recorder Tablature.Soprano Baroque"
      pluginType: "dialog"
      
      id:window
      width: 150; height: 70;

      Label {
        id: textLabel
        wrapMode: Text.WordWrap
        text: qsTr("Font size:")
        font.pointSize:11
        anchors.left: window.left
        anchors.top: window.top
        anchors.leftMargin: 10
        anchors.topMargin: 10
        }

      SpinBox {
        id:fontSize
        anchors.top: window.top
        anchors.left: textLabel.right
        anchors.right: window.right
        anchors.topMargin: 10
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        height: 20
        font.pointSize: 11
        minimumValue: 15
        maximumValue: 60
        value: 35
        }

      Button {
        id : buttonOk
        text: qsTr("Ok")
        anchors.bottom: window.bottom
        anchors.left: window.left
        anchors.bottomMargin: 10
        anchors.leftMargin: 50
        isDefault: true
        onClicked: {
            curScore.startCmd();
            placeTab(fontSize.value);
            curScore.endCmd();
            Qt.quit();
            }
        }

      //                               c    c#   d    d#   e    f    f#   g    g#   a    a#   b    C    C#   D    D#   E    F    F#   G    G#   A    A#   B    c    c#   d
      property variant fingerings : [ "a", "z", "s", "x", "d", "f", "v", "g", "b", "h", "n", "j", "q", "2", "w", "3", "e", "r", "5", "t", "6", "y", "7", "u", "i", "9", "o"]
      function placeTab(size){
            var cursor   = curScore.newCursor();
            cursor.staffIdx = 0; // start on first staff
            cursor.voice = 0; // hope that only one voice in score, for recorder :)
            cursor.rewind(0);  // set cursor to start of score
            while (cursor.segment) { // in end segment is null
                  if (cursor.element._name() == "Chord") {
//console.log(cursor.element.stafftext.parent._name());                  
                        var pitch = cursor.element.notes[0].pitch;
                        var index = pitch - 72;
                        if(index >= 0 && index < fingerings.length){ 
                              var text = newElement(Element.STAFF_TEXT);
                              //text.text = "<font face=\"Recorder Fingerings Vertical\"/>"+fingerings[index];
                              text.text = "<font face=\"Recorder Font\"/>"+fingerings[index];
                              text.text = "<font size=\""+size+"\"/>"+text.text;
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