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
    $(".app").draggable({
      handle: ".title",
      containment: "window",
    });
  } else if (action == "close") {
    $(".app").fadeOut(500);
  } else if (action == "refresh") {
    $(".players").html("");

    for (var jobData of data) {
      $(".title").text(configData.jobs[jobData.job].label);

      var sortedPlayers = jobData.players.sort((a, b) => {
        return a.callsign.localeCompare(b.callsign);
      });

      for (var player of sortedPlayers) {
        html = `
          <div class="player" id=player-id-${player.src}>
              <span class="callsign ${player.me ? "me-bold" : ""}" 
              style="background-color: ${
                getCallsignColors(player.callsign, jobData.job).bg
              }; color: ${
          getCallsignColors(player.callsign, jobData.job).fg
        };">${player.callsign}</span>
              <span class="name ${player.me ? "me-bold" : ""}">${
          player.name
        }</span> |
              <span class="grade ${player.me ? "me-bold" : ""}">${
          player.grade
        }</span> - <span class="status ${player.me ? "me-bold" : ""}${
          player.isTalking ? "radio-talking" : ""
        }">
              ${player.channel == 0 ? "Off" : player.channel + "hz"}</span>
          </div>`;

        $(".players").append(html);
      }
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
  var playerElement = $(`#player-id-${src}`);

  if (playerElement.length) {
    playerElement.remove();
  }
}

function setTalkingOnRadio(src, talking) {
  var playerElement = $(`#player-id-${src}`);

  if (playerElement.length) {
    var statusElement = playerElement.find(".status");
    if (talking) {
      statusElement.addClass("radio-talking");
    } else {
      statusElement.removeClass("radio-talking");
    }
  } else {
    console.error(`Player element with src ${src} not found.`);
  }
}

function setPlayerRadio(src, channel) {
  var playerElement = $(`#player-id-${src}`);

  if (playerElement.length) {
    var statusElement = playerElement.find(".status");
    statusElement.text(channel == 0 ? "Off" : channel + "hz");
  } else {
    console.error(`Player element with src ${src} not found.`);
  }
}

function getCallsignColors(callsign, job) {
  if (!configData) {
    console.error("Config data not available yet.");
    return;
  }

  const defaultColors = configData.defaultColors;
  const colors = {
    fg: defaultColors.foregroundColor,
    bg: defaultColors.backgroundColor,
  };

  const jobConfig = configData.jobs[job];

  if (jobConfig) {
    const jobColors = jobConfig.colors;

    if (jobColors) {
      colors.fg = jobColors.foregroundColor;
      colors.bg = jobColors.backgroundColor;
    }

    const jobRanges = jobConfig.ranges;
    const jobSpecials = jobConfig.special;

    const callsignNumber = parseInt(callsign);

    if (!isNaN(callsignNumber)) {
      if (jobRanges) {
        for (const range of jobRanges) {
          if (callsignNumber >= range.start && callsignNumber <= range.end) {
            colors.fg = range.colors.foregroundColor;
            colors.bg = range.colors.backgroundColor;
            break;
          }
        }
      }
    } else if (typeof callsign === "string") {
      if (jobSpecials) {
        for (const prefixData of jobSpecials) {
          const prefix = prefixData.prefix;
          if (callsign.startsWith(prefix)) {
            colors.fg = prefixData.colors.foregroundColor;
            colors.bg = prefixData.colors.backgroundColor;
            break;
          }
        }
      }
    }
  }

  return colors;
}
