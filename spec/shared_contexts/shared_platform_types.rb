shared_context 'platform_types', platform_types: true do
  # names = %w(site artbitrage social_network doorway email)
  let(:platform_types) do
    %w(site artbitrage social_network doorway email)
      .each { |i| create(:platform_type, name: i) }
  end
end
