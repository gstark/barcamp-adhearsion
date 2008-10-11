default {
   rooms = Room.all

   sleep 1
   speak_swift "Welcome to BarCamp Tampa Bay"
   option_chosen ||= variable("SWIFT_DTMF")

   unless option_chosen
     rooms.each_with_index do |room,index|
       speak_swift "Press #{index+1} for the #{room.name}"
       option_chosen ||= variable("SWIFT_DTMF")
       break if option_chosen
     end
     option_chosen ||= input(1)
   end

   room = rooms[ Integer(option_chosen) - 1 ] rescue nil
   if room
      speak_swift "You chose the #{room.name}"

      active_talk = room.talks.active.first
      next_talk   = room.talks.next.first

      speak_swift "Currently.  #{active_talk.speakable_description}" if active_talk
      speak_swift "Next. #{next_talk.speakable_description}"         if next_talk
      speak_swift "There are no more talks scheduled for this room." unless active_talk || next_talk
   else
      speak_swift "I'm sorry, I did not understand your selection."
   end

   speak_swift "Goodbye"
   hangup
}
