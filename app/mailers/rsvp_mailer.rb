class RsvpMailer < ApplicationMailer

  def send_confirmation(rsvp)
    user      = rsvp.user
    event     = rsvp.event
    recipient = formatted_recipient(user)

    # user details
    @user_first_name = user.first_name

    # user status
    @rsvp_status  = rsvp.status
    @attending    = rsvp.accepted_at
    @has_plus_one = @attending && rsvp.plus_one

    # event details
    @event_slug    = event.slug
    @event_name    = event.name
    @event_venue   = event.venue_name
    @event_address = event.venue_address
    @event_date    = "#{event.formatted_start_date}, #{event.year}"
    @event_time    = "#{event.formatted_start_time}-#{event.formatted_end_time}"

    # urls
    @rsvp_url      = "http://www.kcandkate.us/events/#{@event_slug}#rsvp"
    @plus_one_url  = "http://www.kcandkate.us/events/#{@event_slug}#plus-one"
    @gcal_url      = event.gcal_url
    @venue_map_url = event.venue_map_url

    # copy
    @subject = "[RSVP: #{@rsvp_status}] #{@event_name} for KC and Kate: #{@event_date}"

    send_email(recipient, @subject)
  end

  def send_reminder(rsvp)
    user      = rsvp.user
    event     = rsvp.event
    recipient = formatted_recipient(user)

    # user details
    @user_first_name = user.first_name

    # user status
    @unconfirmed  = rsvp.unconfirmed?
    @attending    = rsvp.attending?
    @has_plus_one = rsvp.plus_one

    # event details
    @event_slug    = event.slug
    @event_name    = event.name
    @event_venue   = event.venue_name
    @event_address = event.venue_address
    @event_date    = "#{event.formatted_start_date}, #{event.year}"
    @event_time    = "#{event.formatted_start_time}-#{event.formatted_end_time}"

    # urls
    @rsvp_url      = "http://www.kcandkate.us/events/#{@event_slug}#rsvp"
    @plus_one_url  = "http://www.kcandkate.us/events/#{@event_slug}#plus-one"
    @gcal_url      = event.gcal_url
    @venue_map_url = event.venue_map_url

    # copy
    @days_away = "#{(event.start_time.to_datetime - DateTime.now + 1).to_i}"
    @headline  = @attending ? "ONLY #{@days_away} DAYS UNTIL" : 'REMINDER: RSVP'
    @subject   = "[REMINDER] #{@event_name} for KC and Kate: #{@event_date}"

    # wedding day overrides
    if [6,7].include?(event.id)
      @big_day    = true
      @event_name = 'Wedding'
      @subject    = "[REMINDER] RSVP for KC and Kate's Wedding: #{@event_date}"
    end

    send_email(recipient, @subject)
  end

end
