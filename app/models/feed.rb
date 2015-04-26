class Feed < ActiveRecord::Base
	 attr_accessible :guid, :source_site_id, :url, :title, :summary, :description, :published_at

  def self.update_from_feed(feed_name)
    feed = Feed.find_by_name(feed_name)
    feed_data = Feedjira::Feed.fetch_and_parse(feed.feed_url)
    add_entries(feed_data.entries, feed)
  end

  private
  def self.add_entries(entries, feed)
    entries.each do |entry|
      break if exists? :entry_id => entry.id

        create!(
            :entry_id     => entry.id,
            :feed_id      => feed.id,
            :url          => entry.url,
            :title        => entry.title.sanitize,
            :summary      => entry.summary.sanitize,
            :description  => entry.content.sanitize,
            :published_at => entry.published
        )

      end
    end
  end
end
end
