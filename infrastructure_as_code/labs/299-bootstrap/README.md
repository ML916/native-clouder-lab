# Account bootstrapping

## Background

[MTTR](https://en.wikipedia.org/wiki/Mean_time_to_recovery):

> Mean time to recovery (MTTR) is the average time that a device will take to recover from any failure. Examples of such devices range from self-resetting fuses (where the MTTR would be very short, probably seconds), up to whole systems which have to be repaired or replaced.

[Incident Management](https://en.wikipedia.org/wiki/Computer_security_incident_management):

> Computer security incident management is an administrative function of managing and protecting computer assets, networks and information systems. These systems continue to become more critical to the personal and economic welfare of our society. Organizations (public and private sector groups, associations and enterprises) must understand their responsibilities to the public good and to the welfare of their memberships and stakeholders. This responsibility extends to having a management program for “what to do, when things go wrong.” Incident management is a program which defines and implements a process that an organization may adopt to promote its own welfare and the security of the public.

## Worst Case scenario

Someone hacks the platform and hijacks the cloud account. Every single resource and data point is lost. How long does it take before the service is restored?

A new developer accidentally breaks the environment, deleting most services and a lot of data. How long does it take before the service is restored?

## Objective

- Establish benchmark MTTR (Mean Time to Recovery / Restore)
- Reduce MTTR as much as possible
- Reproducible environment start to finish
