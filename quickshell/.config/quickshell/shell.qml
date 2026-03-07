import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import QtQuick
import QtQuick.Layouts

PanelWindow {
    id: root
    anchors.top: true
    anchors.left: true
    anchors.right: true
    implicitHeight: 25
    color: "transparent"

    property color bg1: "#003636"
    property color bg2: "#004344"
    property color fg: "#6ae8eb"

    // Re-evaluate when workspace list or focus changes
    property var wsValues: Hyprland.workspaces.values
    property int focusedId: Hyprland.focusedWorkspace?.id ?? -1

    function wsState(id) {
        if (focusedId === id) return "focused"
        for (var i = 0; i < wsValues.length; i++) {
            if (wsValues[i].id === id) return "occupied"
        }
        return "empty"
    }

    // Workspaces - absolutely centered
    RowLayout {
        anchors.centerIn: parent
        spacing: 12

        Repeater {
            model: ["一", "二", "三", "四", "五", "六", "七", "八", "九", "十", "󱉼"]

            Text {
                required property int index
                required property string modelData
                property int wsId: index + 1
                property string state: wsState(wsId)

                text: modelData
                color: state === "focused" ? "#FFC500" : state === "occupied" ? "#8affff" : "#4d7f7f"
                font.family: "Noto Sans CJK SC"
                font.pixelSize: 13
                font.bold: state === "focused"

                MouseArea {
                    anchors.fill: parent
                    onClicked: Hyprland.dispatch("workspace " + wsId)
                }
            }
        }
    }

    // Left modules
    RowLayout {
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        spacing: -1

        // Wlan module
        Rectangle {
            color: root.bg1
            Layout.fillHeight: true
            implicitWidth: wlanRow.implicitWidth + 16

            RowLayout {
                id: wlanRow
                anchors.centerIn: parent
                spacing: 4

                Text {
                    text: ""
                    id: wlanIcon
                    color: root.fg
                    font.family: "Symbols Nerd Font"
                    font.pixelSize: 12
                }

                Text {
                    id: wlanIface
                    text: "wlo1"
                    color: "#FFC500"
                    font.family: "Source Code Pro"
                    font.pixelSize: 14
                }

                Text {
                    id: wlanSsid
                    color: root.fg
                    font.family: "Source Code Pro"
                    font.pixelSize: 14
                    font.bold: true
                    text: "..."
                }

                Text {
                    id: wlanIp
                    color: root.fg
                    font.family: "Source Code Pro"
                    font.pixelSize: 14
                }
            }

            Timer {
                interval: 5000
                running: true
                repeat: true
                triggeredOnStart: true
                onTriggered: wlanProc.running = true
            }

            Process {
                id: wlanProc
                command: ["sh", "-c", "WIFACE=$(ip -o link show up | grep -oP 'wl[^:]+' | head -1); EIFACE=$(ip -o link show up | grep -oP 'en[^:]+' | head -1); if [ -n \"$WIFACE\" ]; then SSID=$(iwgetid -r 2>/dev/null); IP=$(ip -4 -o addr show $WIFACE 2>/dev/null | cut -d' ' -f7 | cut -d/ -f1); echo \"wifi $WIFACE $SSID $IP\"; elif [ -n \"$EIFACE\" ]; then IP=$(ip -4 -o addr show $EIFACE 2>/dev/null | cut -d' ' -f7 | cut -d/ -f1); echo \"eth $EIFACE $IP\"; else echo disconnected; fi"]
                stdout: StdioCollector {
                    onStreamFinished: {
                        var parts = this.text.trim().split(" ")
                        var type = parts[0]
                        if (type === "wifi") {
                            wlanIcon.text = ""
                            wlanIface.text = parts[1]
                            wlanSsid.text = parts[2] || ""
                            wlanSsid.color = root.fg
                            wlanSsid.font.bold = true
                            wlanIp.text = parts[3] || ""
                        } else if (type === "eth") {
                            wlanIcon.text = "ETH_ICON"
                            wlanIface.text = parts[1]
                            wlanSsid.text = ""
                            wlanIp.text = parts[2] || ""
                        } else {
                            wlanIcon.text = "󱚼"
                            wlanIface.text = ""
                            wlanSsid.text = "DISCONNECTED"
                            wlanSsid.color = "#707880"
                            wlanSsid.font.bold = false
                            wlanIp.text = ""
                        }
                    }
                }
            }
        }

        // Powerline separator: bg1 -> transparent
        Text {
            text: ""
            color: root.bg1
            font.family: "Inconsolata for Powerline"
            font.pixelSize: 25
            Layout.fillHeight: true
            verticalAlignment: Text.AlignVCenter
        }
    }

    // Right modules
    RowLayout {
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        spacing: -1

        // Powerline separator: transparent -> bg1
        Text {
            text: ""
            color: root.bg1
            font.family: "Inconsolata for Powerline"
            font.pixelSize: 25
            Layout.fillHeight: true
            verticalAlignment: Text.AlignVCenter
        }


        // Volume module
        Rectangle {
            color: root.bg1
            Layout.fillHeight: true
            implicitWidth: volRow.implicitWidth + 16

            RowLayout {
                id: volRow
                anchors.centerIn: parent
                spacing: 4

                Text {
                    id: volIcon
                    text: ""
                    color: root.fg
                    font.family: "Symbols Nerd Font"
                    font.pixelSize: 12
                }

                Text {
                    id: volText
                    color: root.fg
                    font.family: "Source Code Pro"
                    font.pixelSize: 14
                }
            }

            Timer {
                interval: 1000
                running: true
                repeat: true
                triggeredOnStart: true
                onTriggered: volProc.running = true
            }

            Process {
                id: volProc
                command: ["sh", "-c", "wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{if (/MUTED/) print \"MUTED\"; else printf \"%.0f%%\", $2*100}'"]
                stdout: StdioCollector {
                    onStreamFinished: { var out = this.text.trim(); var muted = (out === "MUTED"); volText.text = out; volIcon.text = muted ? "" : "" }
                }
            }
        }

        // Powerline separator: bg1 -> bg2
        Text {
            text: ""
            color: root.bg2
            font.family: "Inconsolata for Powerline"
            font.pixelSize: 25
            Layout.fillHeight: true
            verticalAlignment: Text.AlignVCenter

            Rectangle {
                anchors.fill: parent
                color: root.bg1
                z: -1
            }
        }
        // RAM module
        Rectangle {
            color: root.bg2
            Layout.fillHeight: true
            implicitWidth: ramRow.implicitWidth + 16

            property string ramOutput: ""

            RowLayout {
                id: ramRow
                anchors.centerIn: parent
                spacing: 4

                Text {
                    text: ""
                    color: root.fg
                    font.family: "Symbols Nerd Font"
                    font.pixelSize: 12
                }

                Text {
                    id: ramText
                    color: root.fg
                    font.family: "Source Code Pro"
                    font.pixelSize: 14
                }
            }

            Timer {
                interval: 2000
                running: true
                repeat: true
                triggeredOnStart: true
                onTriggered: ramProc.running = true
            }

            Process {
                id: ramProc
                command: ["sh", "-c", "free -b | awk '/^Mem:/ {printf \"%.1f/%.1fGB\", $3/1073741824, $2/1073741824}'"]
                stdout: StdioCollector {
                    onStreamFinished: ramText.text = this.text.trim()
                }
            }
        }

        // Powerline separator: bg2 -> bg1
        Text {
            text: ""
            color: root.bg1
            font.family: "Inconsolata for Powerline"
            font.pixelSize: 25
            Layout.fillHeight: true
            verticalAlignment: Text.AlignVCenter

            Rectangle {
                anchors.fill: parent
                color: root.bg2
                z: -1
            }
        }

        // CPU module
        Rectangle {
            color: root.bg1
            Layout.fillHeight: true
            implicitWidth: cpuRow.implicitWidth + 16

            RowLayout {
                id: cpuRow
                anchors.centerIn: parent
                spacing: 4

                Text {
                    text: ""
                    color: root.fg
                    font.family: "Symbols Nerd Font"
                    font.pixelSize: 12
                }

                Text {
                    id: cpuText
                    color: root.fg
                    font.family: "Source Code Pro"
                    font.pixelSize: 14
                }
            }

            Timer {
                interval: 2000
                running: true
                repeat: true
                triggeredOnStart: true
                onTriggered: cpuProc.running = true
            }

            Process {
                id: cpuProc
                command: ["sh", "-c", "awk '/^cpu / {u=$2+$4; t=$2+$3+$4+$5+$6+$7+$8; printf \"%.0f%%\", u*100/t}' /proc/stat"]
                stdout: StdioCollector {
                    onStreamFinished: cpuText.text = this.text.trim()
                }
            }
        }

        // Powerline separator: bg1 -> bg2
        Text {
            text: ""
            color: root.bg2
            font.family: "Inconsolata for Powerline"
            font.pixelSize: 25
            Layout.fillHeight: true
            verticalAlignment: Text.AlignVCenter

            Rectangle {
                anchors.fill: parent
                color: root.bg1
                z: -1
            }
        }

        // Date module
        Rectangle {
            color: root.bg2
            Layout.fillHeight: true
            implicitWidth: dateRow.implicitWidth + 16

            RowLayout {
                id: dateRow
                anchors.centerIn: parent
                spacing: 4

                Text {
                    text: ""
                    color: root.fg
                    font.family: "Symbols Nerd Font"
                    font.pixelSize: 12
                }

                Text {
                    id: dateText
                    color: root.fg
                    font.family: "Source Code Pro"
                    font.pixelSize: 14

                    property var dayKanji: ["日", "月", "火", "水", "木", "金", "土"]

                    Timer {
                        interval: 1000
                        running: true
                        repeat: true
                        triggeredOnStart: true
                        onTriggered: {
                            var now = new Date()
                            var y = now.getFullYear()
                            var m = String(now.getMonth() + 1).padStart(2, '0')
                            var d = String(now.getDate()).padStart(2, '0')
                            dateText.text = y + "年" + m + "月" + d + "日 (" + dateText.dayKanji[now.getDay()] + ")"
                        }
                    }
                }
            }
        }

        // Powerline separator: bg2 -> bg1
        Text {
            text: ""
            color: root.bg1
            font.family: "Inconsolata for Powerline"
            font.pixelSize: 25
            Layout.fillHeight: true
            verticalAlignment: Text.AlignVCenter

            Rectangle {
                anchors.fill: parent
                color: root.bg2
                z: -1
            }
        }

        // Time module
        Rectangle {
            color: root.bg1
            Layout.fillHeight: true
            implicitWidth: timeRow.implicitWidth + 16

            RowLayout {
                id: timeRow
                anchors.centerIn: parent
                spacing: 4

                Text {
                    text: "󰥔"
                    color: root.fg
                    font.family: "Symbols Nerd Font"
                    font.pixelSize: 12
                }

                Text {
                    id: timeText
                    color: root.fg
                    font.family: "Source Code Pro"
                    font.pixelSize: 14

                    Timer {
                        interval: 100
                        running: true
                        repeat: true
                        triggeredOnStart: true
                        onTriggered: {
                            var now = new Date()
                            timeText.text = now.toLocaleTimeString(Qt.locale(), "HH:mm:ss")
                        }
                    }
                }
            }
        }
    }
}
