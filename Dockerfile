FROM liferay/release-candidates:testathon-2025.q4

# Copy all config files placed on the folder configs/ to the Liferay Portal
# bundle.
COPY configs /opt/liferay/osgi/configs/

# Copy the portal-ext.properties placed on the folder properties/ to the Liferay
# Portal bundle.
COPY properties/portal-ext.properties /opt/liferay/