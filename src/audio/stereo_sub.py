import rclpy
from rclpy.node import Node
from std_msgs.msg import Int16MultiArray
import wave
import numpy as np

class AudioSubscriber(Node):

    def __init__(self):
        super().__init__('audio_subscriber')
        self.subscription = self.create_subscription(
            Int16MultiArray,
            'audio',
            self.listener_callback,
            10)
        self.subscription  # prevent unused variable warning
        self.frames = []
        self.rate = 16000  # Same rate as the publisher
        self.channels = 2  # Changed to 2 channels for stereo
        self.sample_width = 2  # 16-bit audio (2 bytes)
        self.output_filename = 'received_audio.wav'
        self.get_logger().info('Audio Subscriber node has been started.')

    def listener_callback(self, msg):
        # Convert the flat list back to 2D array for stereo audio
        audio_data = np.array(msg.data, dtype=np.int16).reshape(-1, self.channels)
        self.frames.append(audio_data.tobytes())
        self.get_logger().info(f'Received audio data: {len(msg.data)} samples')

    def save_to_wav(self):
        with wave.open(self.output_filename, 'wb') as wf:
            wf.setnchannels(self.channels)
            wf.setsampwidth(self.sample_width)
            wf.setframerate(self.rate)
            wf.writeframes(b''.join(self.frames))
        self.get_logger().info(f'Audio data saved to {self.output_filename}')

def main(args=None):
    rclpy.init(args=args)

    audio_subscriber = AudioSubscriber()

    try:
        rclpy.spin(audio_subscriber)
    except KeyboardInterrupt:
        pass
    finally:
        audio_subscriber.save_to_wav()
        audio_subscriber.destroy_node()
        rclpy.shutdown()

if __name__ == '__main__':
    main()
