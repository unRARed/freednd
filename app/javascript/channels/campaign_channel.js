import consumer from "./consumer"

$(document).on('turbolinks:load', function() {
  consumer.subscriptions.create({
      channel: 'CampaignChannel',
      id: $('#campaign').data('id')
    },

    {
      // Called when the subscription is ready for use on the server
      connected() { },

      // Called when the subscription has been terminated by the server
      disconnected() { },

      // Called when there's incoming data on the websocket for this channel
      received(data) {
        if (!data['dice_roll']) { return; }
        const $diceRolls = $('#dice-rolls');

        while ($diceRolls.find('.notification').length >= 5) {
          $diceRolls.find('.notification').last().remove();
        }
        const $diceRollResult = $(data['dice_roll']);
        $diceRollResult.dismissible();
        $diceRolls.prepend($diceRollResult);
        setTimeout(function () {
          $diceRollResult.fadeOut('normal', function () { $(this).remove(); });
        }, 10000)
      }
    }
  );
});
