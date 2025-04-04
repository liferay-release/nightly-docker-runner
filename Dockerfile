FROM liferay/dxp:7.4.13.nightly

# Copy all config files placed on the folder configs/ to the Liferay Portal
# bundle.
COPY configs/*.config /opt/liferay/osgi/configs/

# Copy the portal-ext.properties placed on the folder properties/ to the Liferay
# Portal bundle.
COPY properties/portal-ext.properties /opt/liferay/