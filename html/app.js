let configData = null;

$(document).ready(function () {
  fetch("../colors.json")
    .then((response) => {
      if (!response.ok) {
        throw new Error(`HTTP error! Status: ${response.status}`);
      }
      return response.json();
    })
    .then((data) => (configData = data))
    .catch((error) => {
      console.error("Error fetching colors.json:", error);
    });

  $("body").on("keyup", function (key) {
    if (key.which === 113 || key.which == 27 || key.which == 90) {
      $.post(`http://${GetParentResourceName()}/Close`);
    }
  });
});

window.addEventListener("message", function (event) {
  let action = event.data.action;
  let data = event.data.data;

  if (action == "open") {
    $(".app").fadeIn(500);
  } else if (action == "drag") {
    $(".app").fadeIn(500);
    dragElement(document.getElementById("app"));
  } else if (action == "close") {
    $(".app").fadeOut(500);
  } else if (action == "refresh") {
    $(".officers").html("");
    var officers = data.sort((a, b) => {
      return a.callsign - b.callsign;
    });

    let title =
      officers.length > 1
        ? officers.length + " Active Officers"
        : officers.length + " Active Officer";

    $(".title").text(title);

    for (var officer of officers) {
      html = `
        <div class="officer" id=officer-id-${officer.src}>
            <span class="callsign ${officer.me ? "me-bold" : ""}" 
            style="background-color: ${
              getCallsignColors(officer.callsign).bg
            }; color: ${getCallsignColors(officer.callsign).fg};">${
        officer.callsign
      }</span>
            <span class="name ${officer.me ? "me-bold" : ""}">${
        officer.name
      }</span> |
            <span class="grade ${officer.me ? "me-bold" : ""}">${
        officer.grade
      }</span> - <span class="status ${officer.me ? "me-bold" : ""}${
        officer.isTalking ? "radio-talking" : ""
      }">
            ${officer.channel == 0 ? "Off" : officer.channel + "hz"}</span>
        </div>`;

      $(".officers").append(html);
    }
  } else if (action == "removePlayer") {
    removePlayer(data.src);
  } else if (action == "setTalkingOnRadio") {
    setTalkingOnRadio(data.src, data.talking);
  } else if (action == "setPlayerRadio") {
    setPlayerRadio(data.src, data.channel);
  }
});

function removePlayer(src) {
  var officerElement = $(`#officer-id-${src}`);

  if (officerElement.length) {
    officerElement.remove();
  }
}

function setTalkingOnRadio(src, talking) {
  var officerElement = $(`#officer-id-${src}`);

  if (officerElement.length) {
    var statusElement = officerElement.find(".status");
    if (talking) {
      statusElement.addClass("radio-talking");
    } else {
      statusElement.removeClass("radio-talking");
    }
  } else {
    console.error(`Officer element with src ${src} not found.`);
  }
}

function setPlayerRadio(src, channel) {
  var officerElement = $(`#officer-id-${src}`);

  if (officerElement.length) {
    var statusElement = officerElement.find(".status");
    statusElement.text(channel == 0 ? "Off" : channel + "hz");
  } else {
    console.error(`Officer element with src ${src} not found.`);
  }
}

function getCallsignColors(callsign) {
  if (!configData) {
    console.error("Config data not available yet.");
    return;
  }

  const defaultColors = configData.defaultColors;
  const colors = {
    fg: defaultColors.foregroundColor,
    bg: defaultColors.backgroundColor,
  };

  const callsignNumber = parseInt(callsign);

  if (!isNaN(callsignNumber)) {
    // If callsign can be parsed as an integer, use ranges
    for (const range of configData.ranges) {
      if (callsignNumber >= range.start && callsignNumber <= range.end) {
        colors.fg = range.colors.foregroundColor;
        colors.bg = range.colors.backgroundColor;
        break;
      }
    }
  } else if (typeof callsign === "string") {
    // If callsign is a string, check for special prefixes
    for (const prefixData of configData.special) {
      const prefix = prefixData.prefix;
      if (callsign.startsWith(prefix)) {
        colors.fg = prefixData.colors.foregroundColor;
        colors.bg = prefixData.colors.backgroundColor;
        break;
      }
    }
  }

  return colors;
}

function dragElement(elmnt) {
  var pos1 = 0,
    pos2 = 0,
    pos3 = 0,
    pos4 = 0;

  var header = $(".title");

  if (header.length) {
    // If present, the header is where you move the DIV from:
    header.on("mousedown", dragMouseDown);
  } else {
    // Otherwise, move the DIV from anywhere inside the DIV:
    $(elmnt).on("mousedown", dragMouseDown);
  }

  function dragMouseDown(e) {
    e.preventDefault();

    // Check if the mouse is over the header during dragging
    var isHeaderClicked = $(e.target).is(header);

    // If not over the header, allow resizing
    if (!isHeaderClicked) {
      return;
    }

    // Get the mouse cursor position at startup:
    pos3 = e.clientX;
    pos4 = e.clientY;

    $(document).on("mouseup", closeDragElement);
    // Call a function whenever the cursor moves:
    $(document).on("mousemove", elementDrag);
  }

  function elementDrag(e) {
    e.preventDefault();

    // Calculate the new cursor position:
    pos1 = pos3 - e.clientX;
    pos2 = pos4 - e.clientY;
    pos3 = e.clientX;
    pos4 = e.clientY;

    // Set the element's new position:
    elmnt.style.top = elmnt.offsetTop - pos2 + "px";
    elmnt.style.left = elmnt.offsetLeft - pos1 + "px";
  }

  function closeDragElement() {
    // Stop moving when the mouse button is released:
    $(document).off("mouseup", closeDragElement);
    $(document).off("mousemove", elementDrag);
  }
}
