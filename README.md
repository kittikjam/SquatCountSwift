Migrating my Flutter project for counting and analysis Squat form into a Swift-only project.

In order to reproduce Flutter repo, required next steps include:
- MediaPipe integration to replace the placeholder "Workout session" text.
- Squat detection, landmark smoothing and rep counting
- Form analysis for depth, tempo, balance, torso position and left/right asymmetry.
- Handle poor tracking, missing landmarks and incomplete reps.
- Meaningful live feedback and accurate scoring after each set.
- Proper support for the different exercise and assessment modes already shown in the UI
- Real-device camera testing, performance tuning and automated tests. The main screens and workout flow are already in place, including the camera view, positioning guide, results, progress and profile sections.
